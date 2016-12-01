//
//  RxExtension.swift
//  BitTrader
//
//  Created by chako on 2016/11/29.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation

import APIKit
import RxCocoa
import RxSwift

// MARK: Session
extension Session {
    func rx_sendRequest<T: Request>(request: T) -> Observable<T.Response> {
        return Observable.create { observer in
            let task = self.send(request) { result in
                switch result {
                case .success(let res):
                    observer.on(.next(res))
                    observer.on(.completed)
                case .failure(let err):
                    observer.onError(err)
                }
            }
            return Disposables.create { [weak task] in
                task?.cancel()
            }
        }
    }
    
    class func rx_sendRequest<T: Request>(request: T) -> Observable<T.Response> {
        return shared.rx_sendRequest(request: request)
    }
}

extension Reactive where Base: UIPickerView {
}
