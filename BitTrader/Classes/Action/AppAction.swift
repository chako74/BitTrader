//
//  AppAction.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/27.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import ReSwift

enum AppAction: Action {

    case ProductCodeType(Bitflyer.ProductCodeType)
    case Order(OldEnums.Order)

    case RateModel(RateModel?)

    case ChildOrderCondition(OldEnums.Place, value: ChildOrderCondition)

    case BidAsk(OldEnums.Place, value: OldEnums.BidAsk)
    case Amount(OldEnums.Place, value: String?)
    case Price(OldEnums.Place, value: Double?)
    case TriggerPrice(OldEnums.Place, value: Double?)
    case TrailDistance(OldEnums.Place, value: Double?)
}

func childOrderCondition(place: OldEnums.Place, condition: OldEnums.Condition) -> Store<State>.ActionCreator {
    return { state, store in
        switch condition {
        case .limit:
            store.dispatch(AppAction.ChildOrderCondition(place, value: .limit(bidAsk: .bid, amount: nil, price: nil)))
        case .market:
            store.dispatch(AppAction.ChildOrderCondition(place, value: .market(bidAsk: .bid, amount: nil)))
        case .stop:
            store.dispatch(AppAction.ChildOrderCondition(place, value: .stop(bidAsk: .bid, amount: nil, triggerPrice: nil)))
        case .stopLimit:
            store.dispatch(AppAction.ChildOrderCondition(place, value: .stopLimit(bidAsk: .bid, amount: nil, price: nil, triggerPrice: nil)))
        case .trail:
            store.dispatch(AppAction.ChildOrderCondition(place, value: .trail(bidAsk: .bid, amount: nil, trailDistance: nil)))
        default:
            break
        }
        return nil
    }
}

let executeApi: Store<State>.AsyncActionCreator = { state, store, callback in

    SendOrderUtils.createBitflyerFxTickerRequestExecuter().execute { result in
        switch result {
        case .success(let rateModel):
            callback {_, _ in
                return AppAction.RateModel(rateModel)
            }
        case .failure:
            callback {_, _ in
                return AppAction.RateModel(nil)
            }
        }
    }
}
