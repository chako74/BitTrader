//
//  SimpleOrderReducer.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/30.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import ReSwift

struct SimpleOrderReducer {

    static func handle(state: SimpleOrderState?, action: Action) -> SimpleOrderState {
        var state = state ?? initialSimpleOrderState()

        switch action {
        case _ as ReSwiftInit:
            state.sendOrderCommon = SendOrderCommonReducer.handle(state: state.sendOrderCommon, action: action)

        default:
            break
        }

        return state
    }

    static func initialSimpleOrderState() -> SimpleOrderState {
        return SimpleOrderState(sendOrderCommon: SendOrderCommonReducer.initialSendOrderCommonState())
    }
}
