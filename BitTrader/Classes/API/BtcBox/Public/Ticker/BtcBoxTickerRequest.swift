//
//  BtcBoxTickerRequest.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/18.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

struct BtcBoxTickerRequest: BtcBoxRequest {

    typealias Response = BtcBoxTickerResponse

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return "/api/v1/ticker/"
    }
}
