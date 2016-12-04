//
//  SendOrderReducer.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/27.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import ReSwift

struct SendOrderReducer: Reducer {

    func handleAction(action: Action, state: State?) -> State {
        var state = state ?? State()

        switch action {
        case _ as ReSwiftInit:
            break
        case let action as AppAction:
            switch action {
            case .ProductCodeType(let productType):
                state.sendOrderState.productType = productType

            case .Order(let order):
                state.sendOrderState.order = order

            case .RateModel(let rateModel):
                state.rateModel = rateModel

            default:
                break
            }
        default:
            break
        }

        return state
    }
}
