//
//  BTCChangerViewController.swift
//  BitTrader
//
//  Created by chako on 2016/10/12.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

import APIKit
import RxCocoa
import RxSwift

class BTCChangerViewController: UIViewController, NumberPadViewDelegate {

    private let disposeBag = DisposeBag()
    private let btcChangerViewModel = BTCChangerViewModel()
    
    @IBOutlet private weak var btcPlusMinusInput: PlusMinusInputField?
    @IBOutlet private weak var satoshiPlusMinusInput: PlusMinusInputField?
    @IBOutlet private weak var yenLabel: UILabel?
    @IBOutlet private weak var clearButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btcPlusMinusInput!.format = "%.8f"
        satoshiPlusMinusInput!.format = "%.0f"
        
        bind()
        subscribeRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didDone(_ numberPadViewController: NumberPadViewController, value: String) {
        // 通常のdelegate呼び出し
        print("didDone:" + value)
    }

    func didCancel(_ numberPadViewController: NumberPadViewController) {
        // 通常のdelegate呼び出し
        print("didCancel")
    }

    private func bind() {
        
        btcPlusMinusInput!.input
            .asObservable()
            .map() { input -> Double? in
                guard input != nil else {
                    return nil
                }
                return input! / 0.00000001
            }
            .filter { $0 != self.satoshiPlusMinusInput?.input.value }
            .subscribe(onNext: { [weak self] input in
                self?.satoshiPlusMinusInput?.input.value = input
            })
            .addDisposableTo(disposeBag)
        
        satoshiPlusMinusInput!.input
            .asObservable()
            .map { input -> Double? in
                guard input != nil else {
                    return nil
                }
                return input! * 0.00000001
            }
            .subscribe(onNext: { [weak self] input in
                self?.btcPlusMinusInput?.input.value = input
                self?.btcChangerViewModel.btcAmount.value = input
            })
            .addDisposableTo(disposeBag)
        
        clearButton!.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.btcPlusMinusInput?.input.value = Double(0)
                self?.satoshiPlusMinusInput?.input.value = Double(0)
            })
            .addDisposableTo(disposeBag)

        btcPlusMinusInput?.didTap
            .flatMapLatest { _ in
                return NumberPadViewController.rx.createWithParent(self.rootViewController()) { $0.delegate = self }
                    .flatMap { $0.rx.didDone }
                    .skipWhile { !self.isValid( $0, value: $1) }
                    .take(1)
            }
            .map { $1 != "" ? Double($1) : nil }
            .bindTo((btcPlusMinusInput?.input)!)
            .addDisposableTo(disposeBag)

        satoshiPlusMinusInput?.didTap
            .flatMapLatest { _ in
                return NumberPadViewController.rx.createWithParent(self.rootViewController()) { $0.delegate = self }
                    .flatMap { $0.rx.didDone }
                    .skipWhile { !self.isValid( $0, value: $1) }
                    .take(1)
            }
            .map { $1 != "" ? Double($1) : nil }
            .bindTo((satoshiPlusMinusInput?.input)!)
            .addDisposableTo(disposeBag)
        
        Observable
            .combineLatest(self.btcChangerViewModel.btcAmount.asObservable(),
                           self.btcChangerViewModel.midPrice.asObservable()) { (amount, midPrice) -> String in
                            guard amount != nil else {
                                return ""
                            }
                            return String(amount! * Double(midPrice))
            }
            .bindTo(yenLabel!.rx.text)
            .addDisposableTo(disposeBag)
    }
    
    private func subscribeRequest() {
        
        let rxTimer = Observable<Int>
            .interval(3.0, scheduler: MainScheduler.instance)
            .startWith(0)
            .shareReplay(1)
        
        let backgroundScheduler = SerialDispatchQueueScheduler(qos: .default)
        rxTimer
            .subscribeOn(backgroundScheduler)
            .flatMap {_ -> Observable<GetBoardRequest.Response> in
                let request = GetBoardRequest(requestParameter: GetBoardRequestParameter(productCode: .fxBtcJpy))
                return Session.rx_sendRequest(request: request)
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                self?.btcChangerViewModel.midPrice.value = Int(response.midPrice)
            })
            .addDisposableTo(disposeBag)
    }

    private func isValid(_ numberPadViewController: NumberPadViewController, value: String) -> Bool {
        if value == "0" {
            self.presentAlert(numberPadViewController, message: "0はダメです。")
            return false
        }
        return true
    }

    private func presentAlert(_ parent: UIViewController?, message: String, title: String? = "") {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .cancel))
        parent?.present(alertView, animated: true, completion: nil)
    }

    private func rootViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow!.rootViewController
    }
}
