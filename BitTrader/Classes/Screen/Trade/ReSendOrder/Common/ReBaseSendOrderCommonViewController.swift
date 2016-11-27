//
//  ReReBaseSendOrderCommonViewController.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/26.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

protocol ReSendOrderViewControllerProtocol: NSObjectProtocol {
    func reSendOrderViewModel() throws -> ReSendOrderViewModel
}

class ReBaseSendOrderCommonViewController: UIViewController, ReSendOrderViewControllerProtocol {

    func reSendOrderViewModel() throws -> ReSendOrderViewModel {
        fatalError("reSendOrderViewModel() has not been implemented")
    }

    func rootViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow!.rootViewController
    }
}
