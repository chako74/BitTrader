//
//  OrderListAction.swift
//  BitTrader
//
//  Created by chako on 2016/11/13.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import ReSwift

import APIKit

struct OrderListAction {
    
    struct RequestStartAction: Action {}
    
    struct RequestFinishedAction: Action {
        let items: [BitflyerOrderModel]
    }
    
    struct RequestErrorAction: Action {
        let error: Error
    }

    static func requestOrderListAsyncAction(requestParameter: BitflyerGetChildOrdersParameter?) -> Store<OrderListState>.AsyncActionCreator {
        
        return { (state, store, callback) in
            
            callback { _, _ in
                OrderListAction.RequestStartAction()
            }

            let request = BitflyerGetChildOrdersRequest(requestParameter: requestParameter)            
            Session.send(request) { result in
                
                switch result {
                case .success(let response):
                    callback { _, _ in
                        OrderListAction.RequestFinishedAction(items: response.orderModels)
                    }
                    
                case .failure(let error):
                    callback { _, _ in
                        OrderListAction.RequestErrorAction(error: error)
                    }
                }
            }
        }
    }
}
