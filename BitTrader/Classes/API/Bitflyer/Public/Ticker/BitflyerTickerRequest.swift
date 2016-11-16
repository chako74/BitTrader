//
//  BitflyerTickerRequest.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/18.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

struct BitflyerTickerRequest: BitTraderRequest {

    typealias Response = BitflyerTickerResponse

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return "/v1/ticker"
    }
}
