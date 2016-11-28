//
//  SendOrderCommonReducer.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/30.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import ReSwift

struct SendOrderCommonReducer {

    static func handle(state: SendOrderCommonState?, action: Action) -> SendOrderCommonState {
        var state = state ?? initialSendOrderCommonState()

        switch action {
        case _ as ReSwiftInit:
            state.limitOrder = LimitOrderReducer.handle(state: state.limitOrder, action: action)

        default:
            break
        }

        return state
    }

    static func initialSendOrderCommonState() -> SendOrderCommonState {
        return SendOrderCommonState(limitOrder: LimitOrderReducer.initialLimitOrderState())
    }
    
}
