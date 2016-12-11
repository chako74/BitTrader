//
//  SendOrderRootViewController.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/21.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

protocol SendOrderRootViewControllerProtocol: NSObjectProtocol {
    func willNeedBidPrice(rateType: RateType) -> String?
    func willNeedAskPrice(rateType: RateType) -> String?
}

class SendOrderRootViewController: UIViewController, ViewContainer, UIPickerViewDelegate, UIPickerViewDataSource, ApiExecuterDelegate, SendOrderRootViewControllerProtocol {

    private var activeViewController: BaseSendOrderViewController?

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

        activeViewController = SimpleOrderViewController(productType: productType, condition: .limit, delegete: self)
        addChildContainerViewController(activeViewController!, atContainerView: containerView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.pickerView.dataSource = self
        self.pickerView.delegate = self

        priceApi()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.priceApi), userInfo: nil, repeats: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        timer?.invalidate()
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

    func willNeedBidPrice(rateType: RateType) -> String? {
        guard let response = response else {
            return nil
        }
        return String(describing: response.bestBid)
    }

    func willNeedAskPrice(rateType: RateType) -> String? {
        guard let response = response else {
            return nil
        }
        return String(describing: response.bestAsk)
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
                let newAvc = createOrderViewController(productType, selectedOrder, selectedCondition) else {
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

    func priceApi() {
        guard let productType = productType else {
            return
        }
        let apiExecuter = createBitflyerFxTickerRequestExecuter(productType)
        apiExecuter.delegate = self
        apiExecuter.execute()
    }

    @IBAction func onBidButton(_ sender: UIButton) {
        guard let response = response else {
            return
        }
        activeViewController?.updateBidPrice(price: String(describing: response.bestBid))
    }

    @IBAction func onAskButton(_ sender: UIButton) {
        guard let response = response else {
            return
        }
        activeViewController?.updateAskPrice(price: String(describing: response.bestAsk))
    }

    private func createOrderViewController(_ productType: Bitflyer.ProductCodeType, _ order: Enums.Order, _ condition: Enums.Condition) -> BaseSendOrderViewController? {
        switch order {
        case .simple:
            return SimpleOrderViewController(productType: productType, condition: condition, delegete: self)
        case .ifd:
            return IfdOrderViewController(productType: productType, condition: condition, delegete: self)
        case .oco:
            return OcoOrderViewController(productType: productType, condition: condition, delegete: self)
        case .ifdoco:
            return IfdocoOrderViewController(productType: productType, condition: condition, delegete: self)
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
