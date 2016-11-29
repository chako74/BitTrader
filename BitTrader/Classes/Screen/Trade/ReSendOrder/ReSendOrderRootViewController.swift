//
//  ReReSendOrderRootViewController.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/21.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit
import ReSwift

class ReSendOrderRootViewController: UIViewController, ViewContainer, UIPickerViewDelegate, UIPickerViewDataSource, ApiExecuterDelegate, StoreSubscriber {

    private var activeViewController: ReBaseSendOrderViewController?

    private var productType: Bitflyer.ProductCodeType?
    private var selectedOrder: Enums.Order?
    private var selectedCondition: Enums.Condition?
    private var response: BitflyerTickerResponse?
    private var timer: Timer?

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var bidRateLabel: UILabel!
    @IBOutlet weak var askRateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        productType = .fxBtcJpy

        guard let productType = productType else {
            return
        }

        title = productType.rawValue

        selectedOrder = Enums.Order(rawValue: 0)
        selectedCondition = Enums.Condition(rawValue: 0)

        activeViewController = ReSimpleOrderViewController(productType: productType, condition: .limit)
        addChildContainerViewController(activeViewController!, atContainerView: containerView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        store.subscribe(self) { state in
            state.sendOrderState
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.pickerView.dataSource = self
        self.pickerView.delegate = self

        ratePolling()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.ratePolling), userInfo: nil, repeats: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        store.unsubscribe(self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        timer?.invalidate()
    }

    func newState(state: SendOrderState) {
        guard state.rate == nil, let response = response else {
            return
        }

        let reta: String
        switch state.bidAsk {
        case .bid:
            reta = String(describing: response.bestBid)
        case .ask:
            reta = String(describing: response.bestAsk)
        }
        store.dispatch(SendOrderAction(bidAsk: state.bidAsk, rate: reta))
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return Enums.Order.count
        }
        return Enums.Condition.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return Enums.Order(rawValue: row)?.name
        }
        return Enums.Condition(rawValue: row)?.name
    }

    func onSuccess<ApiExecuter: ApiExecuterProtocol>(_ apiExecuter: ApiExecuter, value: ApiExecuter.ModelType) {
        guard apiExecuter.modelType == BitflyerTickerResponse.self, let response = value as? BitflyerTickerResponse else {
            return
        }
        self.response = response
        bidRateLabel.text = NSNumber(integerLiteral: response.bestBid).formatComma()
        askRateLabel.text = NSNumber(integerLiteral: response.bestAsk).formatComma()
    }

    func onFailure<ApiExecuter: ApiExecuterProtocol>(_ apiExecuter: ApiExecuter, error: ApiResponseError) {

    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            // 注文方法の更新
            selectedOrder = Enums.Order(rawValue: row)
            guard let activeViewController = activeViewController,
                let productType = productType,
                let selectedOrder = selectedOrder,
                let selectedCondition = selectedCondition,
                let newAvc = RecreateOrderViewController(productType, selectedOrder, selectedCondition) else {
                return
            }
            removeChildContainerViewController(activeViewController)
            self.activeViewController = newAvc
            addChildContainerViewController(newAvc, atContainerView: containerView)

        case 1:
            // 注文の執行条件の更新
            selectedCondition = Enums.Condition(rawValue: row)
            guard let selectedCondition = selectedCondition else {
                return
            }
            activeViewController?.updateCondition(selectedCondition)
        default:
            break
        }
    }

    func ratePolling() {
        guard let productType = productType else {
            return
        }
        let apiExecuter = createBitflyerFxTickerRequestExecuter(productType)
        apiExecuter.delegate = self
        apiExecuter.execute()
    }

    @IBAction func onBidButton(_ sender: UIButton) {
        guard let response = response else {
            store.dispatch(SendOrderAction(bidAsk: .bid, rate: nil))
            return
        }

        store.dispatch(SendOrderAction(bidAsk: .bid, rate: String(describing: response.bestBid)))
    }

    @IBAction func onAskButton(_ sender: UIButton) {
        guard let response = response else {
            store.dispatch(SendOrderAction(bidAsk: .ask, rate: nil))
            return
        }

        store.dispatch(SendOrderAction(bidAsk: .ask, rate: String(describing: response.bestAsk)))
    }

    private func RecreateOrderViewController(_ productType: Bitflyer.ProductCodeType, _ order: Enums.Order, _ condition: Enums.Condition) -> ReBaseSendOrderViewController? {
        switch order {
        case .simple:
            return ReSimpleOrderViewController(productType: productType, condition: condition)
        case .ifd:
            return ReIfdOrderViewController(productType: productType, condition: condition)
        case .oco:
            return ReOcoOrderViewController(productType: productType, condition: condition)
        case .ifdoco:
            return ReIfdocoOrderViewController(productType: productType, condition: condition)
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
