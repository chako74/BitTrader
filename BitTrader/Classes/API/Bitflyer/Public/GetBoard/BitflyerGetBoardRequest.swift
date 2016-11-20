//
//  BitflyerGetBoardRequest.swift
//  BitTrader
//
//  Created by chako on 2016/10/14.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

struct BitflyerGetBoardRequest: BitTraderRequest {

    typealias Response = BitflyerGetBoardResponse

    var requestParameter: BitflyerGetBoardRequestParameter?
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/v1/getboard"
    }    
}
