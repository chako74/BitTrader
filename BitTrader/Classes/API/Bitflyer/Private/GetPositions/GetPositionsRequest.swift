//
//  GetPositionsRequest.swift
//  BitTrader
//
//  Created by chako on 2016/11/03.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

struct GetPositionsRequest: BitTraderPrivateRequest {
    
    typealias Response = GetPositionsResponse
    
    let requestParameter: BitTraderRequestParameter
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/v1/me/getpositions"
    }
    
    var parameters: Any? {
        return requestParameter.createParameters()
    }
}
