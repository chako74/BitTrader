//
//  OrderListReducer.swift
//  BitTrader
//
//  Created by chako on 2016/11/13.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import ReSwift

struct OrderListReducer: Reducer {
    
    func handleAction(action: Action, state: OrderListState?) -> OrderListState {
        
        switch action {
        case _ as OrderListAction.RequestStartAction:
            return OrderListState(requestStatus: .requesting, orderList: Array<OrderModel>(), error: nil)
            
        case let action as OrderListAction.RequestFinishedAction:
            return OrderListState(requestStatus: .requested, orderList: action.items, error: nil)
            
        case let action as OrderListAction.RequestErrorAction:
            return OrderListState(requestStatus: .requested, orderList: state?.orderList ?? Array<OrderModel>(), error: action.error)
            
        default:
            return state ?? OrderListState(requestStatus: .none, orderList: Array<OrderModel>(), error: nil)
        }
    }
}
