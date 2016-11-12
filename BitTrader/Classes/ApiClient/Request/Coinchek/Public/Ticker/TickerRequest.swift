//
//  TickerRequest.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/14.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import APIKit

struct TickerRequest: CoinchekRequestProtocol {

    typealias Response = TickerResponse

    var path: String {
        return "/api/ticker"
    }
}
