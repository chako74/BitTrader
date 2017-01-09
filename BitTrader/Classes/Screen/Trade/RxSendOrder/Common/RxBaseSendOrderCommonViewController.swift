//
//  RxBaseSendOrderCommonViewController.swift
//  BitTrader
//
//  Created by chako on 2016/11/26.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

protocol RxSendOrderViewControllerProtocol: NSObjectProtocol {
    
    func executeOrder(confirm: @escaping (_ message: String, _ cancelTitle: String, _ okTitle: String) -> Observable<String>,
                      success: @escaping () -> Void,
                      failure: @escaping (String) -> Void) throws
}

class RxBaseSendOrderCommonViewController: UIViewController, RxSendOrderViewControllerProtocol {
    
    func executeOrder(confirm: @escaping (_ message: String, _ cancelTitle: String, _ okTitle: String) -> Observable<String>,
                      success: @escaping () -> Void,
                      failure: @escaping (String) -> Void) throws {
        fatalError("executeOrder() has not been implemented")
    }
    
    func rootViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow!.rootViewController
    }
}
