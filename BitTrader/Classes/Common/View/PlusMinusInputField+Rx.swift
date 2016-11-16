//
//  PlusMinusInputField+Rx.swift
//  BitTrader
//
//  Created by chako on 2016/11/15.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: PlusMinusInputField {

    var delegate: DelegateProxy {
        return RxPlusMinusInputFieldDelegateProxy.proxyForObject(base)
    }
    
    var didTaped: Observable<PlusMinusInputField> {
        return RxPlusMinusInputFieldDelegateProxy.proxyForObject(base).didTapedSubject
    }
    
    var plusMinusInputFieldValueChanged: Observable<(PlusMinusInputField, changedValue: Double?)> {
        return RxPlusMinusInputFieldDelegateProxy.proxyForObject(base).plusMinusInputFieldValueChangedSubject
    }
}
