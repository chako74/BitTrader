//
//  ReReSendOrderRootViewController.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/21.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit
import ReSwift

class ReSendOrderRootViewController: UIViewController, ViewContainer, UIPickerViewDelegate, UIPickerViewDataSource, StoreSubscriber {

    private var activeViewController: ReBaseSendOrderViewController = ReSimpleOrderViewController(productType: store.state.sendOrderState.productType)
    private var timer: Timer?

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var bidRateLabel: UILabel!
    @IBOutlet weak var askRateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = store.state.sendOrderState.productType.rawValue

        addChildContainerViewController(activeViewController, atContainerView: containerView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        store.subscribe(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.pickerView.dataSource = self
        self.pickerView.delegate = self

        priceApi()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.priceApi), userInfo: nil, repeats: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        store.unsubscribe(self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        timer?.invalidate()
    }

    func newState(state: State) {

        exchangeChildContainerView(productType: state.sendOrderState.productType, order: state.sendOrderState.order)

        if let rateModel = state.rateModel {
            bidRateLabel.text = NSNumber(integerLiteral: rateModel.bidPrice).formatComma()
            askRateLabel.text = NSNumber(integerLiteral: rateModel.askPrice).formatComma()
        }
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return OldEnums.Order.count
        }
        return OldEnums.Condition.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return OldEnums.Order(rawValue: row)?.name
        }
        return OldEnums.Condition(rawValue: row)?.name
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            if let order = OldEnums.Order(rawValue: row) {
                store.dispatch(AppAction.Order(order))
            }
        case 1:
            if let condition = OldEnums.Condition(rawValue: row) {
                store.dispatch(childOrderCondition(place: .First, condition: condition))
            }
        default:
            break
        }
    }

    func priceApi() {
        store.dispatch(executeApi)
    }

    @IBAction func onBidButton(_ sender: UIButton) {
        store.dispatch(AppAction.BidAsk(.First, value: .bid))
    }

    @IBAction func onAskButton(_ sender: UIButton) {
        store.dispatch(AppAction.BidAsk(.First, value: .ask))
    }

    private func exchangeChildContainerView(productType: Bitflyer.ProductCodeType, order: OldEnums.Order) {

        guard let newAvc = recreateOrderViewController(productType, order),
            type(of: activeViewController) != type(of: newAvc) else {
            return
        }

        removeChildContainerViewController(activeViewController)
        self.activeViewController = newAvc
        addChildContainerViewController(newAvc, atContainerView: containerView)
    }

    private func recreateOrderViewController(_ productType: Bitflyer.ProductCodeType,
                                             _ order: OldEnums.Order) -> ReBaseSendOrderViewController? {
        switch order {
        case .simple:
            return ReSimpleOrderViewController(productType: productType)
        case .ifd:
            return ReIfdOrderViewController(productType: productType)
        case .oco:
            return ReOcoOrderViewController(productType: productType)
        case .ifdoco:
            return ReIfdocoOrderViewController(productType: productType)
        default:
            return nil
        }
    }
}
