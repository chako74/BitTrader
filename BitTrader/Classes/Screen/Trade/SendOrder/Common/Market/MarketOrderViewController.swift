//
//  MarketOrderViewController.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

class MarketOrderViewController: BaseSendOrderCommonViewController {

    @IBOutlet weak var amountPlusMinusInput: PlusMinusInputField!

    override func initComponent() {

        amountPlusMinusInput.upDownUnit = Double(0.001)
        amountPlusMinusInput.format = "%.3f"
        amountPlusMinusInput.delegate = self
    }

    override func sendOrderViewModel() throws -> SendOrderViewModel {
        guard let size = amountPlusMinusInput.input.value else {
            throw BitTraderError.ValidationError(message: "size is required")
        }
        return SendOrderViewModel(side: bidButton.isSelected ? .bid : .ask,
                                  size: size,
                                  orderType: .market)
    }

}
