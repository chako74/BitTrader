//
//  BitflyerGetPositionsRequest.swift
//  BitTrader
//
//  Created by chako on 2016/11/03.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

struct BitflyerGetPositionsRequest: BitTraderPrivateRequest {
    
    typealias Response = BitflyerGetPositionsResponse
    
    var requestParameter: BitflyerGetPositionsParameter?
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/v1/me/getpositions"
    }    
}
