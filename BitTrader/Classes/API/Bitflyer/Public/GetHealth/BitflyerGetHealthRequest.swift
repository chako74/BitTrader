//
//  BitflyerGetHealthRequest.swift
//  BitTrader
//
//  Created by chako on 2016/10/07.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

struct BitflyerGetHealthRequest: BitTraderRequest {

    typealias Response = BitflyerGetHealthResponse
    
    var requestParameter: BitflyerGetHealthRequestParameter?
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/v1/gethealth"
    }
}
