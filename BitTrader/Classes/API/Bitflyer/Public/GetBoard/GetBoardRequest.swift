//
//  GetBoardRequest.swift
//  BitTrader
//
//  Created by chako on 2016/10/14.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

struct GetBoardRequest: BitTraderRequest {
    
    typealias Response = GetBoardResponse
    
    let requestParameter: BitTraderRequestParameter?
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/v1/getboard"
    }
    
    var parameters: Any? {
        if let requestParameter = self.requestParameter {
            return requestParameter.createParameters()
        } else {
            return nil
        }
    }
}
