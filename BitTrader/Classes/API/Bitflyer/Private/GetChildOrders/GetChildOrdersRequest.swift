//
//  GetChildOrdersRequest.swift
//  BitTrader
//
//  Created by chako on 2016/10/10.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

struct GetChildOrdersRequest: BitTraderPrivateRequest {
    
    typealias Response = GetChildOrdersResponse
    
    let requestParameter: BitTraderRequestParameter?
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/v1/me/getchildorders"
    }
    
    var parameters: Any? {
        if let requestParameter = self.requestParameter {
            return requestParameter.createParameters()
        } else {
            return nil
        }
    }
}
