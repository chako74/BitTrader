//
//  RxBaseSendOrderCommonViewController.swift
//  BitTrader
//
//  Created by chako on 2016/11/26.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

protocol RxSendOrderViewControllerProtocol: NSObjectProtocol {
    func updateBidPrice(price: String)
    func updateAskPrice(price: String)
    func sendOrderViewModel() throws -> RxSendOrderModel
}

class RxBaseSendOrderCommonViewController: UIViewController, RxSendOrderViewControllerProtocol {

    func updateBidPrice(price: String) {
        fatalError("updateBidPrice(price:) has not been implemented")
    }

    func updateAskPrice(price: String) {
        fatalError("updateAskPrice(price:) has not been implemented")
    }

    func sendOrderViewModel() throws -> RxSendOrderModel {
        fatalError("sendOrderViewModel() has not been implemented")
    }

    func rootViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow!.rootViewController
    }
}
