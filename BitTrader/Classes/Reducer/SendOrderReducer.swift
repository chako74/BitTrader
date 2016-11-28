//
//  SendOrderReducer.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/27.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import ReSwift

func SendOrderReducer(state: SendOrderState?, action: Action) -> SendOrderState {
    var state = state ?? initialSendOrder()

    switch action {
    case _ as ReSwiftInit:
        break
    case let action as SendOrderAction:
        state.bidAsk = action.bidAsk
        state.rate = action.rate
    default:
        break
    }

    return state
}

func initialSendOrder() -> SendOrderState {
    return SendOrderState(bidAsk: .bid,
                          rate: nil)
}
