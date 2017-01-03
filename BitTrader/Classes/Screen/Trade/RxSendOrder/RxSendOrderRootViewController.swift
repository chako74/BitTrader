//
//  RxSendOrderRootViewController.swift
//  BitTrader
//
//  Created by chako on 2016/11/21.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

protocol RxSendOrderRootViewControllerProtocol: NSObjectProtocol {
    func willNeedBidPrice(rateType: RateType) -> String?
    func willNeedAskPrice(rateType: RateType) -> String?
}

class RxSendOrderRootViewController: UIViewController, ViewContainer, UIPickerViewDelegate, UIPickerViewDataSource, RxSendOrderRootViewControllerProtocol {

    private let disposeBag = DisposeBag()
    private let viewModel = RxSendOrderViewModel(productType: .fxBtcJpy, order: .simple)
    
    private var activeViewController: RxBaseSendOrderViewController?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var bidRateLabel: UILabel!
    @IBOutlet weak var askRateLabel: UILabel!
    @IBOutlet weak var bidButton: UIButton!
    @IBOutlet weak var askButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 銘柄変更
        viewModel.productType
            .asDriver()
            .drive(onNext: { [weak self] productType in
                self?.title = productType.rawValue
            })
        .addDisposableTo(disposeBag)

        bindPicker()
        bindRate()
        bindRateButton()
        bindLifeCycle()
    }

    private func bindPicker() {
        
        /* PickerのRx化はdatasource,delegateのRx化も必要なので、今後調査
         pickerView.rx.itemSelected
         .subscribe(onNext: { [weak self] element in
         print(element)
         })
         .addDisposableTo(disposeBag)
         */

        // 注文種別変更
        viewModel.selectedOrder
            .asDriver()
            .drive(onNext: { [weak self] order in
                
                guard let sSelf = self else {
                    return
                }
                if let controller = sSelf.makeOrderViewController(withProductType: sSelf.viewModel.productType.value, order: order) {
                    
                    if let active = sSelf.activeViewController {
                        sSelf.removeChildContainerViewController(active)
                    }
                    sSelf.activeViewController = controller
                    sSelf.addChildContainerViewController(controller, atContainerView: sSelf.containerView)
                }
            })
            .addDisposableTo(disposeBag)        
    }
    
    private func bindRate() {
        
        viewModel.bidRate()
            .asDriver()
            .drive(onNext: { [weak self] bidRate in
                if let bidRate = bidRate {
                    self?.bidRateLabel?.text = NSNumber(integerLiteral: bidRate).formatComma()
                } else {
                    self?.bidRateLabel?.text = ""
                }
            })
            .addDisposableTo(disposeBag)
        
        viewModel.askRate()
            .asDriver()
            .drive(onNext: { [weak self] askRate in
                if let askRate = askRate {
                    self?.askRateLabel?.text = NSNumber(integerLiteral: askRate).formatComma()
                } else {
                    self?.askRateLabel?.text = ""
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    private func bindRateButton() {
        
        bidButton?.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let sSelf = self else {
                    return
                }
                sSelf.viewModel.setSelectedBidAsk(.bid)
            })
            .addDisposableTo(disposeBag)
        
        askButton?.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let sSelf = self else {
                    return
                }
                sSelf.viewModel.setSelectedBidAsk(.ask)
            })
            .addDisposableTo(disposeBag)
    }

    private func bindLifeCycle() {
        viewDidAppearTrigger
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.subscribe()
            })
            .addDisposableTo(disposeBag)
        
        viewDidDisappearTrigger
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.unsubscribe()
            })
            .addDisposableTo(disposeBag)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.tradeTypeComponentCount()
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.tradeTypeCount(numberOfRowsInComponent: component)
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.tradeTypeTitleForRow(row, forComponent: component)
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        viewModel.updateDidSelectedPicker(row: row, inComponent: component)
    }

    func willNeedBidPrice(rateType: RateType) -> String? {

        // TODO: Rxでは各画面のViewModelから読み取るのでこのメソッドは不要になるはず
        return nil
    }

    func willNeedAskPrice(rateType: RateType) -> String? {
        
        // TODO: Rxでは各画面のViewModelから読み取るのでこのメソッドは不要になるはず
        return nil
    }

    private func makeOrderViewController(withProductType: Bitflyer.ProductCodeType, order: Enums.Order) -> RxBaseSendOrderViewController? {
        switch order {
        case .simple:
            let controller = RxSimpleOrderViewController()
            controller.delegate = self
            return controller
        case .ifd:
            let controller = RxIfdOrderViewController()
            controller.delegate = self
            return controller
        case .oco:
            let controller = RxOcoOrderViewController()
            controller.delegate = self
            return controller
        case .ifdoco:
            let controller = RxIfdocoOrderViewController()
            controller.delegate = self
            return controller
        default:
            return nil
        }
    }
}

extension RxSendOrderRootViewController {
    
    private func trigger(selector: Selector) -> Observable<Void> {
        return rx.sentMessage(selector).map { _ in () }.shareReplay(1)
    }
    
    var viewWillAppearTrigger: Observable<Void> {
        return trigger(selector: #selector(self.viewWillAppear(_:)))
    }
    
    var viewDidAppearTrigger: Observable<Void> {
        return trigger(selector: #selector(self.viewDidAppear(_:)))
    }
    
    var viewWillDisappearTrigger: Observable<Void> {
        return trigger(selector: #selector(self.viewWillDisappear(_:)))
    }
    
    var viewDidDisappearTrigger: Observable<Void> {
        return trigger(selector: #selector(self.viewDidDisappear(_:)))
    }
}
