//
//  BaseSendOrderCommonViewController.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/26.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

protocol SendOrderViewControllerProtocol: NSObjectProtocol {
    func updateBidPrice(price: String)
    func updateAskPrice(price: String)
    func sendOrderViewModel() throws -> SendOrderViewModel
}

class BaseSendOrderCommonViewController: UIViewController, SendOrderViewControllerProtocol, PlusMinusInputFieldDelegate, NumberPadViewDelegate {

    weak var delegate: SendOrderRootViewControllerProtocol?

    @IBOutlet weak var bidButton: BidAskButton!
    @IBOutlet weak var askButton: BidAskButton!
    
    var bidAsk: Enums.BidAsk
    var targetField: PlusMinusInputField?

    init(bidAsk: Enums.BidAsk, delegete: SendOrderRootViewControllerProtocol) {
        self.bidAsk = bidAsk
        self.delegate = delegete
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bidButton.initializeBidAsk(.bid)
        bidButton.title(Enums.BidAsk.bid.rawValue)

        askButton.initializeBidAsk(.ask)
        askButton.title(Enums.BidAsk.ask.rawValue)

        initComponent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        changeBidAsk(bidAsk: bidAsk)
    }

    func updateBidPrice(price: String) {
        changeBidAsk(bidAsk: .bid)
        updatePrice(bidAsk: .bid, price: Double(price)!)
    }

    func updateAskPrice(price: String) {
        changeBidAsk(bidAsk: .ask)
        updatePrice(bidAsk: .ask, price: Double(price)!)
    }

    func sendOrderViewModel() throws -> SendOrderViewModel {
        fatalError("sendOrderViewModel() has not been implemented")
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

    func initComponent() {
    }

    func updatePrice(bidAsk: Enums.BidAsk, price: Double) {
    }

    @IBAction func onBidButton(_ sender: UIButton) {
        guard let price = self.delegate?.willNeedBidPrice(rateType: .bitflyerFx) else {
            return
        }
        updatePrice(bidAsk: .bid, price: Double(price)!)
        changeBidAsk(bidAsk: .bid)
    }

    @IBAction func onAskButton(_ sender: UIButton) {
        guard let price = self.delegate?.willNeedAskPrice(rateType: .bitflyerFx) else {
            return
        }
        updatePrice(bidAsk: .ask, price: Double(price)!)
        changeBidAsk(bidAsk: .ask)
    }

    func changeBidAsk(bidAsk: Enums.BidAsk) {
        bidButton.selected(bidAsk: bidAsk)
        askButton.selected(bidAsk: bidAsk)
    }

    func rootViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow!.rootViewController
    }
}
