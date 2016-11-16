//
//  CoincheckTickerRequest.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/17.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

struct CoincheckTickerRequest: CoincheckRequest {

    typealias Response = CoincheckTickerResponse

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return "/api/ticker"
    }
}
