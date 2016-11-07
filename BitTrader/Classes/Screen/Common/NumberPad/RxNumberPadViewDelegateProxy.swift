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

    fileprivate var _didDoneSubject: PublishSubject<(NumberPadViewController, value: String)>?
    fileprivate var _didCancelSubject: PublishSubject<NumberPadViewController>?

    var didDoneSubject: PublishSubject<(NumberPadViewController, value: String)> {
        if _didDoneSubject == nil {
            let publishSubject = PublishSubject<(NumberPadViewController, value: String)>()
            _didDoneSubject = publishSubject
        }
        return _didDoneSubject!
    }

    var didCancelSubject: PublishSubject<NumberPadViewController> {
        if _didCancelSubject == nil {
            let publishSubject = PublishSubject<NumberPadViewController>()
            _didCancelSubject = publishSubject
        }
        return _didCancelSubject!
    }

    func didCancel(_ numberPadViewController: NumberPadViewController) {
        didCancelSubject.on(.next(numberPadViewController))

        // _forwardToDelegateを利用すると通常のdelegateも呼ぶことができる
        self._forwardToDelegate?.didCancel(numberPadViewController)
    }

    func didDone(_ numberPadViewController: NumberPadViewController, value: String) {
        didDoneSubject.on(.next((numberPadViewController, value: value)))

        // _forwardToDelegateを利用すると通常のdelegateも呼ぶことができる
        self._forwardToDelegate?.didDone(numberPadViewController, value: value)
    }

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
    guard value != nil else {
        return nil
    }
    let v: T = castOrFatalError(value)
    return v
}

private func rxFatalError(_ lastMessage: String) -> Never {
    fatalError(lastMessage)
}
