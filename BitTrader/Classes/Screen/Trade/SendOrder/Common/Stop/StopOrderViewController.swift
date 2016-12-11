//
//  StopOrderViewController.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

class StopOrderViewController: BaseSendOrderCommonViewController {

    @IBOutlet weak var amountPlusMinusInput: PlusMinusInputField!
    @IBOutlet weak var triggerPricePlusMinusInput: PlusMinusInputField!
    
    override func initComponent() {

        amountPlusMinusInput.upDownUnit = Double(0.001)
        amountPlusMinusInput.format = "%.3f"
        amountPlusMinusInput.delegate = self

        triggerPricePlusMinusInput.format = "%.0f"
        triggerPricePlusMinusInput.delegate = self
    }

    override func sendOrderViewModel() throws -> SendOrderViewModel {
        guard let size = amountPlusMinusInput.input.value else {
            throw BitTraderError.ValidationError(message: "size is required")
        }
        guard let triggerPrice = triggerPricePlusMinusInput.input.value else {
            throw BitTraderError.ValidationError(message: "triggerPrice is required")
        }
        return SendOrderViewModel(side: bidButton.isSelected ? .bid : .ask,
                                  size: size,
                                  orderType: .stop(triggerPrice: Int(triggerPrice)))
    }

}
