//
//  ZaifTickerRequest.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/18.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

struct ZaifTickerRequest: ZaifRequest {

    typealias Response = ZaifTickerResponse

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return "/api/1/ticker/btc_jpy"
    }
}
