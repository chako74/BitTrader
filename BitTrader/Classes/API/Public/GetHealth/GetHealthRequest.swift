//
//  GetHealthRequest.swift
//  BitTrader
//
//  Created by chako on 2016/10/07.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

struct GetHealthRequest: BitTraderRequest {
    
    typealias Response = GetHealthResponse
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/v1/gethealth"
    }
}
