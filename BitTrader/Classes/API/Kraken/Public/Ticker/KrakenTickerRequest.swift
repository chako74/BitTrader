//
//  KrakenTickerRequest.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/18.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

struct KrakenTickerRequest: KrakenRequest {

    typealias Response = KrakenTickerResponse

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return "/0/public/Ticker"
    }

    var parameters: Any? {
        return ["pair": "XXBTZJPY"]
    }
}
