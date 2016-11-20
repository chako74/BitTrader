//
//  BitflyerSendChildOrderRequest.swift
//  BitTrader
//
//  Created by chako on 2016/11/20.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

struct BitflyerSendChildOrderRequest: BitTraderPrivateRequest {
    
    typealias Response = BitflyerSendChildOrderResponse
    
    var requestParameter: BitflyerSendChildOrderRequestParameter?
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/v1/me/sendchildorder"
    }
}
