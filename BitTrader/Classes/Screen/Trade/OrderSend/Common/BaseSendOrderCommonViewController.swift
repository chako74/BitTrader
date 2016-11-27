//
//  BaseSendOrderCommonViewController.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/26.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

protocol SendOrderViewControllerProtocol: NSObjectProtocol {
    func updateBidRate(rate: String)
    func updateAskRate(rate: String)
    func sendOrderViewModel() throws -> SendOrderViewModel
}

class BaseSendOrderCommonViewController: UIViewController, SendOrderViewControllerProtocol {

    func updateBidRate(rate: String) {
        fatalError("updateBidRate(rate:) has not been implemented")
    }

    func updateAskRate(rate: String) {
        fatalError("updateAskRate(rate:) has not been implemented")
    }

    func sendOrderViewModel() throws -> SendOrderViewModel {
        fatalError("sendOrderViewModel() has not been implemented")
    }

    func rootViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow!.rootViewController
    }
}
