//
//  LimitOrderViewController.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

class LimitOrderViewController: BaseSendOrderCommonViewController {

    @IBOutlet weak var amountPlusMinusInput: PlusMinusInputField!
    @IBOutlet weak var pricePlusMinusInput: PlusMinusInputField!

    override func initComponent() {

        amountPlusMinusInput.upDownUnit = Double(0.001)
        amountPlusMinusInput.format = "%.3f"
        amountPlusMinusInput.delegate = self

        pricePlusMinusInput.format = "%.0f"
        pricePlusMinusInput.delegate = self
    }

    override func sendOrderViewModel() throws -> SendOrderViewModel {
        guard let size = amountPlusMinusInput.input.value else {
            throw BitTraderError.ValidationError(message: "size is required")
        }
        guard let price = pricePlusMinusInput.input.value else {
            throw BitTraderError.ValidationError(message: "price is required")
        }
        return SendOrderViewModel(side: bidButton.isSelected ? .bid : .ask,
                                  size: size,
                                  orderType: .limit(price: Int(price)))
    }

    override func updatePrice(bidAsk: Enums.BidAsk, price: Double) {
        pricePlusMinusInput.input.value = price
    }
}
