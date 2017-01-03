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
    func executeOrder(success: @escaping () -> Void, failure: @escaping (String) -> Void) throws
}

class RxBaseSendOrderCommonViewController: UIViewController, RxSendOrderViewControllerProtocol {

    func updateBidPrice(price: String) {
        fatalError("updateBidPrice(price:) has not been implemented")
    }

    func updateAskPrice(price: String) {
        fatalError("updateAskPrice(price:) has not been implemented")
    }

    func executeOrder(success: @escaping () -> Void, failure: @escaping (String) -> Void)  throws {
        fatalError("executeOrder() has not been implemented")
    }
    
    func rootViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow!.rootViewController
    }
}
