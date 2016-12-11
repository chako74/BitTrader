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

class BaseSendOrderCommonViewController: UIViewController, SendOrderViewControllerProtocol {

    func updateBidPrice(price: String) {
        fatalError("updateBidPrice(price:) has not been implemented")
    }

    func updateAskPrice(price: String) {
        fatalError("updateAskPrice(price:) has not been implemented")
    }

    func sendOrderViewModel() throws -> SendOrderViewModel {
        fatalError("sendOrderViewModel() has not been implemented")
    }

    func rootViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow!.rootViewController
    }
}
