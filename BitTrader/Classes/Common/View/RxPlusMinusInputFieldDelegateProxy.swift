//
//  RxPlusMinusInputFieldDelegateProxy.swift
//  BitTrader
//
//  Created by chako on 2016/11/15.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

public class RxPlusMinusInputFieldDelegateProxy: DelegateProxy, DelegateProxyType, PlusMinusInputFieldDelegate {
    
    fileprivate var _didTapedSubject: PublishSubject<PlusMinusInputField>?
    fileprivate var _plusMinusInputFieldValueChangedSubject: PublishSubject<(PlusMinusInputField, changedValue: Double?)>?
    
    var didTapedSubject: PublishSubject<PlusMinusInputField> {
        if _didTapedSubject == nil {
            _didTapedSubject = PublishSubject<PlusMinusInputField>()
        }
        return _didTapedSubject!
    }
    
    var plusMinusInputFieldValueChangedSubject: PublishSubject<(PlusMinusInputField, changedValue: Double?)> {
        if _plusMinusInputFieldValueChangedSubject == nil {
            _plusMinusInputFieldValueChangedSubject = PublishSubject<(PlusMinusInputField, changedValue: Double?)>()
        }
        return _plusMinusInputFieldValueChangedSubject!
    }
    
    func didTapedPlusMinusInputField(_ field: PlusMinusInputField) {
        didTapedSubject.on(.next(field))
        
        (forwardToDelegate() as? PlusMinusInputFieldDelegate)?.didTapedPlusMinusInputField(field)
    }
    
    func plusMinusInputField(_ plusMinusInputField: PlusMinusInputField, changedValue: Double?) {
        plusMinusInputFieldValueChangedSubject.on(.next((plusMinusInputField, changedValue: changedValue)))
        
        (forwardToDelegate() as? PlusMinusInputFieldDelegate)?.plusMinusInputField(plusMinusInputField, changedValue: changedValue)
    }
    
    public class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let plusMinusInputField: PlusMinusInputField = castOrFatalError(object)
        plusMinusInputField.delegate = castOptionalOrFatalError(delegate)
    }
    
    public class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let plusMinusInputField: PlusMinusInputField = castOrFatalError(object)
        return plusMinusInputField.delegate
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
