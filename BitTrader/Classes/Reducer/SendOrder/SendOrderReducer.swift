//
//  SendOrderReducer.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/27.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import ReSwift

struct SendOrderReducer {

    static func handle(state: SendOrderState?, action: Action) -> SendOrderState {
        var state = state ?? initialSendOrderState()

        switch action {
        case _ as ReSwiftInit:
            state.simpleOrder = SimpleOrderReducer.handle(state: state.simpleOrder, action: action)

        case let action as SendOrderAction:
            switch action {
            case .Response(let response):
                state.response = response

            case .BidAsk(let bidAsk):
                state.bidAsk = bidAsk
                state.simpleOrder.sendOrderCommon.limitOrder.bidAsk = bidAsk
                state.simpleOrder.sendOrderCommon.limitOrder.rate = bidAskRate(bidAsk, response: state.response)

            case .Order(let order):
                state.order = order

            case .Condition(let condition):
                state.condition = condition

            case .ProductCodeType:
                break
            }

        case let action as LimitOrderAction:
            switch action {
            case .BidAsk(let bidAsk):
                state.bidAsk = bidAsk
                state.simpleOrder.sendOrderCommon.limitOrder.bidAsk = bidAsk
                state.simpleOrder.sendOrderCommon.limitOrder.rate = bidAskRate(bidAsk, response: state.response)

            case .Amount(let amount):
                state.simpleOrder.sendOrderCommon.limitOrder.amount = amount
                
            case .Rate(let rate):
                state.simpleOrder.sendOrderCommon.limitOrder.rate = rate
            }

        default:
            break
        }
        
        return state

    }

    static func initialSendOrderState() -> SendOrderState {
        return SendOrderState(productType: .fxBtcJpy,
                              order: .simple,
                              condition: .limit,
                              bidAsk: .bid,
                              response: nil,
                              simpleOrder: SimpleOrderReducer.initialSimpleOrderState())
    }

    static func bidAskRate(_ bidAsk: Enums.BidAsk, response: BitflyerTickerResponse?) -> Double? {
        guard let response = response else {
            return nil
        }

        let rate: Int
        switch bidAsk {
        case .bid:
            rate = response.bestBid
        case .ask:
            rate = response.bestAsk
        }
        return Double(rate)
    }
}
