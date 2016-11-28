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
    private var timer: Timer?

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var bidRateLabel: UILabel!
    @IBOutlet weak var askRateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = store.state.sendOrderState.productType.rawValue

        activeViewController = ReSimpleOrderViewController(productType: store.state.sendOrderState.productType,
                                                           condition: store.state.sendOrderState.condition)
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

        exchangeChildContainerView(productType: state.productType, order: state.order, condition: state.condition)

        if let response = state.response {

            bidRateLabel.text = NSNumber(integerLiteral: response.bestBid).formatComma()
            askRateLabel.text = NSNumber(integerLiteral: response.bestAsk).formatComma()
        }
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

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            // 注文方法の更新
            guard let order = Enums.Order(rawValue: row) else {
                return
            }
            store.dispatch(SendOrderAction.Order(order))

        case 1:
            // 注文の執行条件の更新
            guard let condition = Enums.Condition(rawValue: row) else {
                return
            }
            store.dispatch(SendOrderAction.Condition(condition))

        default:
            break
        }
    }

    func onSuccess<ApiExecuter: ApiExecuterProtocol>(_ apiExecuter: ApiExecuter, value: ApiExecuter.ModelType) {
        guard apiExecuter.modelType == BitflyerTickerResponse.self, let response = value as? BitflyerTickerResponse else {
            return
        }

        store.dispatch(SendOrderAction.Response(response))
    }

    func onFailure<ApiExecuter: ApiExecuterProtocol>(_ apiExecuter: ApiExecuter, error: ApiResponseError) {
        store.dispatch(SendOrderAction.Response(nil))
    }

    func ratePolling() {
        let productType = store.state.sendOrderState.productType
        let apiExecuter = createBitflyerFxTickerRequestExecuter(productType)
        apiExecuter.delegate = self
        apiExecuter.execute()
    }

    @IBAction func onBidButton(_ sender: UIButton) {
        store.dispatch(SendOrderAction.BidAsk(.bid))
    }

    @IBAction func onAskButton(_ sender: UIButton) {
        store.dispatch(SendOrderAction.BidAsk(.ask))
    }

    private func exchangeChildContainerView(productType: Bitflyer.ProductCodeType, order: Enums.Order, condition: Enums.Condition) {

        guard let activeViewController = activeViewController,
            let newAvc = recreateOrderViewController(productType, order, condition) else {
            return
        }

        removeChildContainerViewController(activeViewController)
        self.activeViewController = newAvc
        addChildContainerViewController(newAvc, atContainerView: containerView)
    }

    private func recreateOrderViewController(_ productType: Bitflyer.ProductCodeType,
                                             _ order: Enums.Order,
                                             _ condition: Enums.Condition) -> ReBaseSendOrderViewController? {
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
