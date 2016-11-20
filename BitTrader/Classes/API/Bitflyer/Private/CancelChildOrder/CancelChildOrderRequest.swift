//
//  CancelChildOrderRequest.swift
//  BitTrader
//
//  Created by chako on 2016/11/20.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

struct CancelChildOrderRequest: BitTraderPrivateRequest {
    
    typealias Response = CancelChildOrderResponse
    
    var requestParameter: CancelChildOrderParameter?
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/v1/me/cancelchildorder"
    }
}
