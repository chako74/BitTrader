//
//  ReReLimitOrderViewController.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/27.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit
import ReSwift

class ReLimitOrderViewController: ReBaseSendOrderCommonViewController, PlusMinusInputFieldDelegate, NumberPadViewDelegate, StoreSubscriber {

    private var targetField: PlusMinusInputField?

    @IBOutlet weak var bidButton: UIButton!
    @IBOutlet weak var askButton: UIButton!
    @IBOutlet weak var amountPlusMinusInput: PlusMinusInputField!
    @IBOutlet weak var pricePlusMinusInput: PlusMinusInputField!

    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        store.subscribe(self) { state in
            state.parentOrderState
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }

    func newState(state: ParentOrderState) {
        let cos = SendOrderUtils.selectOrderState(parentOrderState: state, place: place)

        changeBidAsk(bidAsk: cos.condition.bidAsk)

        if let amount = cos.condition.amount {
            amountPlusMinusInput.input.value = Double(amount)
        }

        if let price = cos.condition.price {
            pricePlusMinusInput.input.value = Double(price)
        }
    }

    func initComponent() {
        let bidImage = UIColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.3).toImage()
        let bidSelectedImage = UIColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.7).toImage()
        bidButton.setBackgroundImage(bidImage, for: .normal)
        bidButton.setBackgroundImage(bidImage, for: .highlighted)
        bidButton.setBackgroundImage(bidSelectedImage, for: .selected)
        bidButton.setBackgroundImage(bidImage, for: .disabled)

        let askImage = UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.3).toImage()
        let askSelectedImage = UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.7).toImage()
        askButton.setBackgroundImage(askImage, for: .normal)
        askButton.setBackgroundImage(askImage, for: .highlighted)
        askButton.setBackgroundImage(askSelectedImage, for: .selected)
        askButton.setBackgroundImage(askImage, for: .disabled)

        amountPlusMinusInput.upDownUnit = Double(0.001)
        amountPlusMinusInput.format = "%.3f"
        amountPlusMinusInput.delegate = self

        pricePlusMinusInput.format = "%.0f"
        pricePlusMinusInput.delegate = self
    }

    override func reSendOrderViewModel() throws -> ReSendOrderViewModel {

        guard let state = store.state.parentOrderState.simple else {
            fatalError("state is nil")
        }

        guard let size = state.condition.amount else {
            throw BitTraderError.ValidationError(message: "size is required")
        }
        guard let price = state.condition.price else {
            throw BitTraderError.ValidationError(message: "price is required")
        }

        return ReSendOrderViewModel(side: state.condition.bidAsk,
                                    size: Double(size)!,
                                    orderType: .limit(price: Int(price)))
    }

    func didTapedPlusMinusInputField(_ field: PlusMinusInputField) {
        targetField = field
        guard let rootViewController = rootViewController() else {
            return
        }
        let numberPad = NumberPadViewController()
        numberPad.delegate = self
        numberPad.modalPresentationStyle = .overCurrentContext
        numberPad.view.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.6)
        rootViewController.present(numberPad, animated: true, completion: nil)
    }

    func plusMinusInputField(_ plusMinusInputField: PlusMinusInputField, changedValue: Double?) {
        guard let value = changedValue else {
            return
        }

        if plusMinusInputField == amountPlusMinusInput {
            store.dispatch(AppAction.Amount(.First, value: String(value)))
        } else if plusMinusInputField == pricePlusMinusInput {
            store.dispatch(AppAction.Rate(.First, value: value))
        }
    }

    func didDone(_ numberPadViewController: NumberPadViewController, value: String) {
        guard let rootViewController = rootViewController() else {
            return
        }

        if targetField == amountPlusMinusInput {
            store.dispatch(AppAction.Amount(.First, value: value))
        } else if targetField == pricePlusMinusInput {
            store.dispatch(AppAction.Rate(.First, value: Double(value)!))
        }

        rootViewController.dismiss(animated: true, completion: nil)
    }

    func didCancel(_ NumberPadViewController: NumberPadViewController) {
        guard let rootViewController = rootViewController() else {
            return
        }
        rootViewController.dismiss(animated: true, completion: nil)
    }

    @IBAction func onBidButton(_ sender: UIButton) {
        store.dispatch(AppAction.BidAsk(.First, value: .bid))
    }

    @IBAction func onAskButton(_ sender: UIButton) {
        store.dispatch(AppAction.BidAsk(.First, value: .ask))
    }

    private func changeBidAsk(bidAsk: Enums.BidAsk) {
        switch bidAsk {
        case .bid:
            bidButton.isSelected = true
            askButton.isSelected = false
        case .ask:
            bidButton.isSelected = false
            askButton.isSelected = true
        }
    }
}
