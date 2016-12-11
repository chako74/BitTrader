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
    func willNeedBidRate(rateType: RateType) -> String?
    func willNeedAskRate(rateType: RateType) -> String?
}

class RxSendOrderRootViewController: UIViewController, ViewContainer, UIPickerViewDelegate, UIPickerViewDataSource, ApiExecuterDelegate, RxSendOrderRootViewControllerProtocol {

    private let disposeBag = DisposeBag()
    private let viewModel = RxSendOrderViewModel(productType: .fxBtcJpy, order: .simple, condition: .limit)
    
    private var activeViewController: RxBaseSendOrderViewController?
    
    private var response: BitflyerTickerResponse?
    private var timer: Timer?

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var bidRateLabel: UILabel!
    @IBOutlet weak var askRateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 銘柄変更
        viewModel.productType
            .asDriver()
            .drive(onNext: { [weak self] productType in
                self?.title = productType.rawValue
            })
        .addDisposableTo(disposeBag)

        // 注文種別変更
        viewModel.selectedOrder
            .asDriver()
            .drive(onNext: { [weak self] order in
                
                guard let sSelf = self,
                    let active = sSelf.activeViewController else {
                    return
                }
                if let controller = sSelf.makeOrderViewController(sSelf.viewModel.productType.value, order, sSelf.viewModel.selectedCondition.value) {
                    sSelf.removeChildContainerViewController(active)
                    sSelf.activeViewController = controller
                    sSelf.addChildContainerViewController(controller, atContainerView: sSelf.containerView)
                }
            })
        .addDisposableTo(disposeBag)
        
        // 注文条件変更
        viewModel.selectedCondition
            .asDriver()
            .drive(onNext: { [weak self] condition in
                
                self?.activeViewController?.updateCondition(condition)
            })
        .addDisposableTo(disposeBag)
        
        /* PickerのRx化はdatasource,delegateのRx化も必要なので、今後調査
        pickerView.rx.itemSelected
            .subscribe(onNext: { [weak self] element in
                print(element)
            })
            .addDisposableTo(disposeBag)
         */
        
        let controller = RxSimpleOrderViewController(viewModel: self.viewModel)
        controller.delegate = self
        
        activeViewController = controller
        addChildContainerViewController(activeViewController!, atContainerView: containerView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ratePolling()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.ratePolling), userInfo: nil, repeats: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        timer?.invalidate()
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

    func success<ApiExecuter: ApiExecuterProtocol>(_ apiExecuter: ApiExecuter, value: ApiExecuter.ModelType) {
        guard apiExecuter.modelType == BitflyerTickerResponse.self, let response = value as? BitflyerTickerResponse else {
            return
        }
        self.response = response
        bidRateLabel.text = NSNumber(integerLiteral: response.bestBid).formatComma()
        askRateLabel.text = NSNumber(integerLiteral: response.bestAsk).formatComma()
    }

    func failure<ApiExecuter: ApiExecuterProtocol>(_ apiExecuter: ApiExecuter, error: ApiResponseError) {

    }

    func willNeedBidRate(rateType: RateType) -> String? {
        guard let response = response else {
            return nil
        }
        return String(describing: response.bestBid)
    }

    func willNeedAskRate(rateType: RateType) -> String? {
        guard let response = response else {
            return nil
        }
        return String(describing: response.bestAsk)
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        viewModel.updateDidSelectedPicker(row: row, inComponent: component)        
    }

    func ratePolling() {
        let apiExecuter = createBitflyerFxTickerRequestExecuter(self.viewModel.productType.value)
        apiExecuter.delegate = self
        apiExecuter.execute()
    }

    @IBAction func onBidButton(_ sender: UIButton) {
        guard let response = response else {
            return
        }
        activeViewController?.updateBidRate(rate: String(describing: response.bestBid))
    }

    @IBAction func onAskButton(_ sender: UIButton) {
        guard let response = response else {
            return
        }
        activeViewController?.updateAskRate(rate: String(describing: response.bestAsk))
    }

    private func makeOrderViewController(_ productType: Bitflyer.ProductCodeType, _ order: Enums.Order, _ condition: Enums.Condition) -> RxBaseSendOrderViewController? {
        switch order {
        case .simple:
            let controller = RxSimpleOrderViewController(viewModel: self.viewModel)
            controller.delegate = self
            return controller
        case .ifd:
            let controller = RxIfdOrderViewController(viewModel: self.viewModel)
            controller.delegate = self
            return controller
        case .oco:
            let controller = RxOcoOrderViewController(viewModel: self.viewModel)
            controller.delegate = self
            return controller
        case .ifdoco:
            let controller = RxIfdocoOrderViewController(viewModel: self.viewModel)
            controller.delegate = self
            return controller
        default:
            return nil
        }
    }

    private func createBitflyerFxTickerRequestExecuter(_ productType: Bitflyer.ProductCodeType) -> ApiKitApiExecuter<BitflyerTickerRequest, BitflyerTickerResponse> {
        let bitflyerFxTickerReuqestParameter = BitflyerTickerRequestParameter(productCode: productType)
        let bitflyerFxTickerRequest = BitflyerTickerRequest(requestParameter: bitflyerFxTickerReuqestParameter)
        return ApiKitApiExecuter<BitflyerTickerRequest, BitflyerTickerResponse>(bitflyerFxTickerRequest)
    }
}
