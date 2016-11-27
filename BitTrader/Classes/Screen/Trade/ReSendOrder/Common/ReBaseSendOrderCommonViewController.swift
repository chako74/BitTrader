//
//  ReReBaseSendOrderCommonViewController.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/26.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

protocol ReSendOrderViewControllerProtocol: NSObjectProtocol {
    func updateBidRate(rate: String)
    func updateAskRate(rate: String)
    func reSendOrderViewModel() throws -> ReSendOrderViewModel
}

class ReBaseSendOrderCommonViewController: UIViewController, ReSendOrderViewControllerProtocol {

    func updateBidRate(rate: String) {
        fatalError("updateBidRate(rate:) has not been implemented")
    }

    func updateAskRate(rate: String) {
        fatalError("updateAskRate(rate:) has not been implemented")
    }

    func reSendOrderViewModel() throws -> ReSendOrderViewModel {
        fatalError("reSendOrderViewModel() has not been implemented")
    }

    func rootViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow!.rootViewController
    }
}
