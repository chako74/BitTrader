//
//  RxNumberPadViewDelegateProxy.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/08.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

public class RxNumberPadViewDelegateProxy: DelegateProxy, DelegateProxyType, NumberPadViewDelegate {

    /**
     For more information take a look at `DelegateProxyType`.
     */
    public class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let numberPadViewController: NumberPadViewController = castOrFatalError(object)
        numberPadViewController.delegate = castOptionalOrFatalError(delegate)
    }

    /**
     For more information take a look at `DelegateProxyType`.
     */
    public class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let numberPadViewController: NumberPadViewController = castOrFatalError(object)
        return numberPadViewController.delegate
    }
}

private func castOrFatalError<T>(_ value: Any!) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
        rxFatalError("Failure converting from \(value) to \(T.self)")
    }

    return result
}

private func castOptionalOrFatalError<T>(_ value: AnyObject?) -> T? {
    if value == nil {
        return nil
    }
    let v: T = castOrFatalError(value)
    return v
}

private func rxFatalError(_ lastMessage: String) -> Never {
    // The temptation to comment this line is great, but please don't, it's for your own good. The choice is yours.
    fatalError(lastMessage)
}
