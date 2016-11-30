//
//  LimitOrderReducer.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/30.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import ReSwift

struct LimitOrderReducer {

    static func handle(state: LimitOrderState?, action: Action) -> LimitOrderState {
        var state = state ?? initialLimitOrderState()

        switch action {
        case _ as ReSwiftInit:
            break

        case let action as LimitOrderAction:
            switch action {
            case .BidAsk(let bidAsk):
                state.bidAsk = bidAsk

            case .Amount(let amount):
                state.amount = amount

            case .Rate(let rate):
                state.rate = rate
            }

        default:
            break
        }

        return state
    }

    static func initialLimitOrderState() -> LimitOrderState {
        return LimitOrderState(bidAsk: .bid,
                               amount: nil,
                               rate: nil)
    }
    
}
