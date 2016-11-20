//
//  BitflyerGetBalanceRequest.swift
//  BitTrader
//
//  Created by chako on 2016/10/08.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

struct BitflyerGetBalanceRequest: BitTraderPrivateRequest {
    
    typealias Response = BitflyerGetBalanceResponse
    
    var requestParameter: BitflyerGetBalanceRequestParameter?
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/v1/me/getbalance"
    }
}
