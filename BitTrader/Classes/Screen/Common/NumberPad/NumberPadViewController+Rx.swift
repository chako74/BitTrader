//
//  NumberPadViewController+Rx.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/08.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: NumberPadViewController {

    /**
     Reactive wrapper for `delegate`.

     For more information take a look at `DelegateProxyType` protocol documentation.
     */
    var delegate: DelegateProxy {
        return RxNumberPadViewDelegateProxy.proxyForObject(base)
    }

    /**
     Reactive wrapper for `delegate` message.
     */
    var didDone: Observable<String> {
        return delegate
            .methodInvoked(Selector(("didDone:")))
            .map({ (a) in
                return try castOrThrow(String.self, a[0])
            })
    }

    /**
     Reactive wrapper for `delegate` message.
     */
    var didCancel: Observable<NumberPadViewController> {
        return delegate
            .methodInvoked(Selector(("didCancel:")))
            .map({ (a) in
                return try castOrThrow(NumberPadViewController.self, a[0])
            })
    }
}

fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}
