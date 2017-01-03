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
    private var response: BitflyerTickerResponse?
    private var timer: Timer?

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var bidButton: BidAskButton!
    @IBOutlet weak var askButton: BidAskButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
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
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Enums.Order.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Enums.Order(rawValue: row)?.name
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOrder = Enums.Order(rawValue: row)
        guard let activeViewController = activeViewController,
            let productType = productType,
            let selectedOrder = selectedOrder,
            let newAvc = createOrderViewController(productType, selectedOrder) else {
                return
        }
        removeChildContainerViewController(activeViewController)
        self.activeViewController = newAvc
        addChildContainerViewController(newAvc, atContainerView: containerView)
    }

    func success<ApiExecuter: ApiExecuterProtocol>(_ apiExecuter: ApiExecuter, value: ApiExecuter.ModelType) {
        guard apiExecuter.modelType == BitflyerTickerResponse.self, let response = value as? BitflyerTickerResponse else {
            return
        }
        self.response = response
        bidButton.title(NSNumber(integerLiteral: response.bestBid).formatComma())
        askButton.title(NSNumber(integerLiteral: response.bestAsk).formatComma())
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

    func initComponent() {
        productType = .fxBtcJpy

        guard let productType = productType else {
            return
        }

        title = productType.rawValue

        selectedOrder = Enums.Order(rawValue: 0)

        bidButton.initializeBidAsk(.bid)
        bidButton.font(UIFont(name: (bidButton.titleLabel?.font.fontName)!, size: 30.0)!)
        askButton.initializeBidAsk(.ask)
        askButton.font(UIFont(name: (askButton.titleLabel?.font.fontName)!, size: 30.0)!)

        activeViewController = SimpleOrderViewController(productType: productType, delegete: self)
        addChildContainerViewController(activeViewController!, atContainerView: containerView)
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

    private func createOrderViewController(_ productType: Bitflyer.ProductCodeType, _ order: Enums.Order) -> BaseSendOrderViewController? {
        switch order {
        case .simple:
            return SimpleOrderViewController(productType: productType, delegete: self)
        case .ifd:
            return IfdOrderViewController(productType: productType, delegete: self)
        case .oco:
            return OcoOrderViewController(productType: productType, delegete: self)
        case .ifdoco:
            return IfdocoOrderViewController(productType: productType, delegete: self)
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
