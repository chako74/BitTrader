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

    var didDone: Observable<(NumberPadViewController, value: String)> {
        return RxNumberPadViewDelegateProxy.proxyForObject(base).didDoneSubject
    }

    var didCancel: Observable<NumberPadViewController> {
        return RxNumberPadViewDelegateProxy.proxyForObject(base).didCancelSubject
    }
}

fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}
