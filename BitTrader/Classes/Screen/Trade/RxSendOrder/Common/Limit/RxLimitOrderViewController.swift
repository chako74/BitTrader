//
//  RxLimitOrderViewController.swift
//  BitTrader
//
//  Created by chako on 2016/11/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

class RxLimitOrderViewController: RxBaseSendOrderCommonViewController, PlusMinusInputFieldDelegate, NumberPadViewDelegate {

    weak var delegate: RxSendOrderRootViewControllerProtocol?

    private var bidAsk: Enums.BidAsk
    private var targetField: PlusMinusInputField?

    @IBOutlet weak var bidButton: UIButton!
    @IBOutlet weak var askButton: UIButton!
    @IBOutlet weak var amountPlusMinusInput: PlusMinusInputField!
    @IBOutlet weak var pricePlusMinusInput: PlusMinusInputField!

    init(bidAsk: Enums.BidAsk, delegete: RxSendOrderRootViewControllerProtocol) {
        self.bidAsk = bidAsk
        self.delegate = delegete
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        changeBidAsk(bidAsk: bidAsk)
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

    override func updateBidRate(rate: String) {
        updateRate(bidAsk: .bid, rate: Double(rate)!)
    }

    override func updateAskRate(rate: String) {
        updateRate(bidAsk: .ask, rate: Double(rate)!)
    }

    override func sendOrderViewModel() throws -> RxSendOrderViewModel {
        guard let size = amountPlusMinusInput.input.value else {
            throw BitTraderError.ValidationError(message: "size is required")
        }
        guard let price = pricePlusMinusInput.input.value else {
            throw BitTraderError.ValidationError(message: "price is required")
        }

        return RxSendOrderViewModel(side: bidButton.isSelected ? .bid : .ask,
                                    size: size,
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
    }

    func didDone(_ numberPadViewController: NumberPadViewController, value: String) {
        guard let rootViewController = rootViewController(), let field = targetField else {
            return
        }
        field.input.value = Double(value)
        rootViewController.dismiss(animated: true, completion: nil)
    }

    func didCancel(_ numberPadViewController: NumberPadViewController) {
        guard let rootViewController = rootViewController() else {
            return
        }
        rootViewController.dismiss(animated: true, completion: nil)
    }

    @IBAction func onBidButton(_ sender: UIButton) {
        guard let rate = self.delegate?.willNeedBidRate(rateType: .bitflyerFx) else {
            return
        }
        updateRate(bidAsk: .bid, rate: Double(rate)!)
    }

    @IBAction func onAskButton(_ sender: UIButton) {
        guard let rate = self.delegate?.willNeedAskRate(rateType: .bitflyerFx) else {
            return
        }
        updateRate(bidAsk: .ask, rate: Double(rate)!)
    }

    private func updateRate(bidAsk: Enums.BidAsk, rate: Double) {
        changeBidAsk(bidAsk: bidAsk)
        pricePlusMinusInput.input.value = rate
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
