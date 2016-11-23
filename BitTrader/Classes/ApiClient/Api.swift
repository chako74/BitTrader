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

    static func execute<ApiExecuter: ApiKitApiExecuterProtocol>(_ apiExecuter: ApiExecuter) {

        if let error = apiExecuter.isValid(apiExecuter.request) {
            apiExecuter.delegate?.onFailure(apiExecuter, value: apiExecuter.onFailure(error))
            return
        }

        apiExecuter.willExcecute(apiExecuter.request)

        apiExecuter.execute(apiExecuter.request) { result in

            apiExecuter.didExcecute(result)

            switch result {
            case .success(let res):
                apiExecuter.delegate?.onSuccess(apiExecuter, value: apiExecuter.onSuccess(res))
            case .failure(let error):
                apiExecuter.delegate?.onFailure(apiExecuter, value: apiExecuter.onFailure(error))
            }
        }
    }

    static func rxExecute<ApiExecuter: ApiKitApiExecuterProtocol>(_ apiExecuter: ApiExecuter, _ period: TimeInterval = 3.0)
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
                    .startWith(nil)
            }
    }
}
