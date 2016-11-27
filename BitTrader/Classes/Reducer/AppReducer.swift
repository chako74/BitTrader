//
//  AppReducer.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/27.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import ReSwift

struct AppReducer: Reducer {

    func handleAction(action: Action, state: State?) -> State {
        return State(
            sendOrderState: SendOrderReducer(state: state?.sendOrderState, action: action)
        )
    }
}
