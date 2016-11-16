//
//  Api.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/16.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Result
import RxSwift

class Api {

    private init() {
    }

    static func execute<ApiExecuter: ApiExecuterProtocol>(_ apiExecuter: ApiExecuter) {

        if let error = apiExecuter.isValid(apiExecuter.request) {
            _ = apiExecuter.onFailure(error)
            return
        }

        apiExecuter.willExcecute(apiExecuter.request)

        apiExecuter.execute(apiExecuter.request) { result in

            apiExecuter.didExcecute(result)

            switch result {
            case .success(let res):
                _ = apiExecuter.onSuccess(res)
            case .failure(let err):
                _ = apiExecuter.onFailure(err)
            }
        }
    }

    static func rxExecute<ApiExecuter: ApiExecuterProtocol>(_ apiExecuter: ApiExecuter, _ period: TimeInterval = 3.0)
        -> Observable<ApiExecuter.DTO?> {

            return Observable<Int>
                .interval(period, scheduler: MainScheduler.instance)
                .shareReplay(1)
                .subscribeOn(SerialDispatchQueueScheduler(qos: .default))
                .flatMap {_ -> Observable<ApiExecuter.DTO?> in
                    return Observable<ApiExecuter.DTO?>.create { observer in

                        if let error = apiExecuter.isValid(apiExecuter.request) {
                            observer.onError(apiExecuter.onFailure(error))
                        }

                        apiExecuter.willExcecute(apiExecuter.request)

                        apiExecuter.execute(apiExecuter.request) { result in

                            apiExecuter.didExcecute(result)

                            switch result {
                            case .success(let res):
                                observer.on(.next(apiExecuter.onSuccess(res)))
                                observer.on(.completed)
                            case .failure(let err):
                                observer.onError(apiExecuter.onFailure(err))
                            }
                        }

                        return Disposables.create()
                    }
            }
    }
}
