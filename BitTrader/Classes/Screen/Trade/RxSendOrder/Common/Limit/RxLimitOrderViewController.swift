//
//  RxLimitOrderViewController.swift
//  BitTrader
//
//  Created by chako on 2016/11/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class RxLimitOrderViewController: RxBaseSendOrderCommonViewController {

    private let disposeBag = DisposeBag()
    private let viewModel = RxLimitOrderViewModel()
    
    private var bidAsk: Enums.BidAsk
    private var targetField: PlusMinusInputField?

    @IBOutlet weak var bidButton: BidAskButton!
    @IBOutlet weak var askButton: BidAskButton!
    @IBOutlet weak var amountPlusMinusInput: PlusMinusInputField!
    @IBOutlet weak var pricePlusMinusInput: PlusMinusInputField!

    init(bidAsk: Enums.BidAsk) {
        self.bidAsk = bidAsk
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeComponent()
        
        bindRateButton()
        bindInputAmount()
        bindInputPrice()
    }

    override func executeOrder(confirm: @escaping (_ message: String, _ cancelTitle: String, _ okTitle: String) -> Observable<String>,
                               success: @escaping () -> Void,
                               failure: @escaping (String) -> Void) throws {
        try viewModel.executeOrder(confirm: confirm, success: success, failure: failure)
    }

    private func initializeComponent() {
        
        bidButton.initializeBidAsk(.bid)
        bidButton.font(UIFont(name: (bidButton.titleLabel?.font.fontName)!, size: 30.0)!)
        bidButton.title(Enums.BidAsk.bid.rawValue)
        
        askButton.initializeBidAsk(.ask)
        askButton.font(UIFont(name: (askButton.titleLabel?.font.fontName)!, size: 30.0)!)
        askButton.title(Enums.BidAsk.ask.rawValue)
        
        amountPlusMinusInput.upDownUnit = Double(0.001)
        amountPlusMinusInput.format = "%.3f"
        
        pricePlusMinusInput.format = "%.0f"
    }
    
    private func bindRateButton() {
        
        self.viewModel.selectedBidAsk()
            .asDriver()
            .drive(onNext: { [weak self] selectedBidAsk in
                self?.bidButton?.selected(bidAsk: selectedBidAsk)
                self?.askButton?.selected(bidAsk: selectedBidAsk)
            })
            .addDisposableTo(disposeBag)
        
        bidButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.setSelectedBidAsk(.bid)
            })
            .addDisposableTo(disposeBag)
        
        askButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.setSelectedBidAsk(.ask)
            })
            .addDisposableTo(disposeBag)
    }

    private func bindInputAmount() {
        
        amountPlusMinusInput!.input
            .asDriver()
            .drive(onNext: { [weak self] amount in
                self?.viewModel.openAmount().value = amount
            })
            .addDisposableTo(disposeBag)
        
        amountPlusMinusInput?.rx
            .didTaped
            .flatMapLatest { _ in
                return NumberPadViewController.rx.createWithParent(self.rootViewController())
                    .flatMap { $0.rx.didDone }
                    .take(1)
            }
            .map { $1 != "" ? Double($1) : nil }
            .bindTo(self.viewModel.openAmount())
            .addDisposableTo(disposeBag)
        
        viewModel.openAmount()
            .asDriver()
            .filter({ [weak self] openAmount -> Bool in
                let amount = openAmount ?? 0
                return amount != self?.amountPlusMinusInput.input.value
            })
            .drive(onNext: { [weak self] amount in
                self?.amountPlusMinusInput.input.value = amount
            })
            .addDisposableTo(disposeBag)
    }
    
    private func bindInputPrice() {
        pricePlusMinusInput!.input
            .asDriver()
            .drive(onNext: { [weak self] inputPrice in
                if let price = inputPrice {
                    self?.viewModel.limitPrice.value = Int(price)
                }
            })
            .addDisposableTo(disposeBag)
        
        pricePlusMinusInput?.rx
            .didTaped
            .flatMapLatest { _ in
                return NumberPadViewController.rx.createWithParent(self.rootViewController())
                    .flatMap { $0.rx.didDone }
                    .take(1)
            }
            .map { $1 != "" ? Int($1) : nil }
            .bindTo(self.viewModel.limitPrice)
            .addDisposableTo(disposeBag)
        
        viewModel.limitPrice
            .asDriver()
            .map {
                if let price = $0 {
                    return Double(price)
                }
                return nil
            }
            .filter { [weak self] limitPrice -> Bool in
                let price = limitPrice ?? 0
                return price != self?.pricePlusMinusInput.input.value
            }
            .drive(onNext: { [weak self] limitPrice in
                self?.pricePlusMinusInput.input.value = limitPrice
            })
            .addDisposableTo(disposeBag)
    }
}
