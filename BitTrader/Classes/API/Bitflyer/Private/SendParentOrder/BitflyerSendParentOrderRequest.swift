//
//  BitflyerSendParentOrderRequest.swift
//  BitTrader
//
//  Created by chako on 2016/11/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

struct BitflyerSendParentOrderRequest: BitTraderPrivateRequest {
    
    typealias Response = BitflyerSendParentOrderResponse
    
    var requestParameter: BitflyerSendParentOrderParameter?
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/v1/me/sendparentorder"
    }
}
