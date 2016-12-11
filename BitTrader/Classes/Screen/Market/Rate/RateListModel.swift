//
//  RateListModel.swift
//  BitTrader
//
//  Created by chako on 2016/11/26.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import RxCocoa
import RxSwift

enum RateViewState {
    case initial
    case requesting
    case requested(rateList: Array<RateModel>)
    case error
    case stop
}

class RateListModel {

    private var disposeBag = DisposeBag()
    
    let viewState = Variable(RateViewState.initial)
        
    func fetch() {

        Observable.combineLatest(ApiClient.rxExecute(SendOrderUtils.createBitflyerTickerRequestExecuter()),
                                 ApiClient.rxExecute(SendOrderUtils.createBitflyerFxTickerRequestExecuter()),
                                 ApiClient.rxExecute(SendOrderUtils.createBtcBoxTickerRequestExecuter()),
                                 ApiClient.rxExecute(SendOrderUtils.createCoincheckTickerRequestExecuter()),
                                 ApiClient.rxExecute(SendOrderUtils.createKrakenTickerRequestExecuter()),
                                 ApiClient.rxExecute(SendOrderUtils.createZaifTickerRequestExecuter())) { r in r }
            .scan((nil, nil, nil, nil, nil, nil)) { [weak self] (x, y) throws -> (RateModel?, RateModel?, RateModel?, RateModel?, RateModel?, RateModel?) in
                let v0 = self?.checkNext(x.0, y.0)
                let v1 = self?.checkNext(x.1, y.1)
                let v2 = self?.checkNext(x.2, y.2)
                let v3 = self?.checkNext(x.3, y.3)
                let v4 = self?.checkNext(x.4, y.4)
                let v5 = self?.checkNext(x.5, y.5)
                return (v0, v1, v2, v3, v4, v5)
            }
            .flatMapLatest { (bitflyer, bitflyerFx, btcBox, coincheck, kraken, zaif) -> Observable<[RateModel]> in
                var models = Array<RateModel>()
                models.appendNotNil(element: bitflyer)
                models.appendNotNil(element: bitflyerFx)
                models.appendNotNil(element: btcBox)
                models.appendNotNil(element: coincheck)
                models.appendNotNil(element: kraken)
                models.appendNotNil(element: zaif)
                return .just(models)
            }
            .subscribe(onNext: { models in
                self.viewState.value = RateViewState.requested(rateList: models)
            })
            .addDisposableTo(disposeBag)
    }
    
    func stop() {
        disposeBag = DisposeBag()
    }
    
    private func checkNext(_ prev: RateModel?, _ next: RateModel?) -> RateModel? {
        if prev != nil && next == nil {
            return prev
        }
        return next
    }
}
