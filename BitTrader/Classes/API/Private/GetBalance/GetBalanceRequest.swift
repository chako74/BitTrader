//
//  GetBalanceRequest.swift
//  BitTrader
//
//  Created by chako on 2016/10/08.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

struct GetBalanceRequest: BitTraderPrivateRequest {
    
    typealias Response = GetBalanceResponse
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/v1/me/getbalance"
    }
}
