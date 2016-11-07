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

class BTCChangerViewController: UIViewController {

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
    
    private func bind() {
        
        btcPlusMinusInput!.input
            .asObservable()
            .map() { input -> Double in
                return input / 0.00000001
            }
            .subscribe(onNext: { [weak self] input in
                self?.satoshiPlusMinusInput?.update(input: input)
            })
            .addDisposableTo(disposeBag)
        
        satoshiPlusMinusInput!.input
            .asObservable()
            .map() { input -> Double in
                return input * 0.00000001
            }
            .subscribe(onNext: { [weak self] input in
                self?.btcPlusMinusInput?.update(input: input)
                self?.btcChangerViewModel.btcAmount.value = input
            })
            .addDisposableTo(disposeBag)
        
        clearButton!.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.btcPlusMinusInput!.update(input: 0)
                self?.satoshiPlusMinusInput!.update(input: 0)
            })
            .addDisposableTo(disposeBag)

        btcPlusMinusInput?.didTap
            .flatMapLatest { _ in
                return NumberPadViewController.rx.createWithParent()
                    .flatMap { $0.rx.didDone }
                    .take(1)
            }
            .map { Double($0)! }
            .bindTo((btcPlusMinusInput?.input)!)
            .addDisposableTo(disposeBag)

        satoshiPlusMinusInput?.didTap
            .flatMapLatest { _ in
                return NumberPadViewController.rx.createWithParent()
                    .flatMap { $0.rx.didDone }
                    .take(1)
            }
            .map { Double($0)! }
            .bindTo((satoshiPlusMinusInput?.input)!)
            .addDisposableTo(disposeBag)
        
        Observable
            .combineLatest(self.btcChangerViewModel.btcAmount.asObservable(),
                           self.btcChangerViewModel.midPrice.asObservable()) { (amount, midPrice) -> String in
                            return String(amount * Double(midPrice))
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
}
