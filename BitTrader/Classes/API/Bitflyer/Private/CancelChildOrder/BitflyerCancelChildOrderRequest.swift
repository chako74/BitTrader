//
//  BitflyerCancelChildOrderRequest.swift
//  BitTrader
//
//  Created by chako on 2016/11/20.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

struct BitflyerCancelChildOrderRequest: BitTraderPrivateRequest {
    
    typealias Response = BitflyerCancelChildOrderResponse
    
    var requestParameter: BitflyerCancelChildOrderParameter?
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/v1/me/cancelchildorder"
    }
}
