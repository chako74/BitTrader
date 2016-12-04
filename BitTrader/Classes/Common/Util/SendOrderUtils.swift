//
//  SendOrderUtils.swift
//  BitTrader
//
//  Created by coaractos on 2016/12/09.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation

struct SendOrderUtils {

    private init() {
    }

    static func createBitflyerTickerRequestExecuter() -> ApiKitApiExecuter<BitflyerTickerRequest, RateModel> {
        let bitflyerTickerReuqestParameter = BitflyerTickerRequestParameter(productCode: .btcjpy)
        let bitflyerTickerRequest = BitflyerTickerRequest(requestParameter: bitflyerTickerReuqestParameter)
        return ApiKitApiExecuter(bitflyerTickerRequest, responseConverter: { response in
            return RateModel(rateType:.bitflyer,
                             midPrice: response.ltp,
                             askPrice: response.bestAsk,
                             bidPrice: response.bestBid)
        })
    }

    static func createBitflyerFxTickerRequestExecuter() -> ApiKitApiExecuter<BitflyerTickerRequest, RateModel> {
        let bitflyerFxTickerReuqestParameter = BitflyerTickerRequestParameter(productCode: .fxBtcJpy)
        let bitflyerFxTickerRequest = BitflyerTickerRequest(requestParameter: bitflyerFxTickerReuqestParameter)
        return ApiKitApiExecuter(bitflyerFxTickerRequest, responseConverter: { response in
            return RateModel(rateType:.bitflyerFx,
                             midPrice: response.ltp,
                             askPrice: response.bestAsk,
                             bidPrice: response.bestBid)
        })
    }

    static func createBtcBoxTickerRequestExecuter() -> ApiKitApiExecuter<BtcBoxTickerRequest, RateModel> {
        let btcBoxTickerRequest = BtcBoxTickerRequest()
        return ApiKitApiExecuter(btcBoxTickerRequest, responseConverter: { response in
            return RateModel(rateType:.btcBox,
                             midPrice: response.last,
                             askPrice: response.sell,
                             bidPrice: response.buy)
        })
    }

    static func createCoincheckTickerRequestExecuter() -> ApiKitApiExecuter<CoincheckTickerRequest, RateModel> {
        let coincheckTickerRequest = CoincheckTickerRequest()
        return ApiKitApiExecuter(coincheckTickerRequest, responseConverter: { response in
            return RateModel(rateType:.coincheck,
                             midPrice: response.last,
                             askPrice: response.ask,
                             bidPrice: response.bid)
        })
    }

    static func createKrakenTickerRequestExecuter() -> ApiKitApiExecuter<KrakenTickerRequest, RateModel> {
        let krakenTickerRequest = KrakenTickerRequest()
        return ApiKitApiExecuter(krakenTickerRequest, responseConverter: { response in
            return RateModel(rateType:.kraken,
                             midPrice: Int(floor(atof(response.result!.currencyPair.c.first!))),
                             askPrice: Int(floor(atof(response.result!.currencyPair.a.first!))),
                             bidPrice: Int(floor(atof(response.result!.currencyPair.b.first!))))
        })
    }

    static func createZaifTickerRequestExecuter() -> ApiKitApiExecuter<ZaifTickerRequest, RateModel> {
        let zaifTickerRequest = ZaifTickerRequest()
        return ApiKitApiExecuter(zaifTickerRequest, responseConverter: { response in
            return RateModel(rateType:.zaif,
                             midPrice: response.last,
                             askPrice: response.ask,
                             bidPrice: response.bid)
        })
    }

    static func selectOrderState(parentOrderState: ParentOrderState, place: Enums.Place) -> HasCondition {
        switch place {
        case .First:
            switch parentOrderState {
            case .simple(let state):
                return state
            case .ifd(let state, _):
                return state
            case .oco(let state, _):
                return state
            case .ifdoco(let state, _, _):
                return state
            }
        case .Second:
            switch parentOrderState {
            case .ifd(_, let state):
                return state
            case .oco(_, let state):
                return state
            case .ifdoco(_, let state, _):
                return state
            default:
                fatalError("invalid argument.")
            }
        case .Third:
            switch parentOrderState {
            case .ifdoco(let state, _, _):
                return state
            default:
                fatalError("invalid argument.")
            }
        }
    }
}
