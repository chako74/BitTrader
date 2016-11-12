//
//  TickerResponse.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/15.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import Himotoki

struct TickerResponse: CoinchekResponseProtocol {

    let last: Int
    let bid: Int
    let ask: Int
    let high: Int
    let low: Int
    let volume: String
    let timestamp: Int

    static func decode(_ e: Extractor) throws -> TickerResponse {
        return try self.init(
            last: e <| "last",
            bid: e <| "bid",
            ask: e <| "ask",
            high: e <| "high",
            low: e <| "low",
            volume: e <| "volume",
            timestamp: e <| "timestamp"
        )
    }
}
