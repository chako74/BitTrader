//
//  Api.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/16.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Result
import RxSwift

class ApiClient {

    private init() {
    }

    static func rxExecute<ApiExecuter: ApiExecuterProtocol>(_ apiExecuter: ApiExecuter, _ period: TimeInterval = 3.0)
        -> Observable<ApiExecuter.ModelType?> {

            return Observable<Int>
                .interval(period, scheduler: MainScheduler.instance)
                .shareReplay(1)
                .subscribeOn(SerialDispatchQueueScheduler(qos: .default))
                .flatMap {_ -> Observable<ApiExecuter.ModelType?> in
                    return Observable<ApiExecuter.ModelType?>.create { observer in

                        apiExecuter.execute(apiExecuter.request) { result in
                            switch result {
                            case .success(let response):
                                observer.on(.next(response))
                                observer.on(.completed)
                            case .failure(let error):
                                observer.onError(error)
                            }
                        }

                        return Disposables.create()
                    }
                    .startWith(nil)
            }
    }
}
