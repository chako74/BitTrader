//
//  CoincheckTickerResponse.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/15.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import Himotoki

struct CoincheckTickerResponse {
    let last: Int
    let bid: Int
    let ask: Int
    let high: Int
    let low: Int
    let volume: String
    let timestamp: Int
}

extension CoincheckTickerResponse: Decodable {

    static func decode(_ e: Extractor) throws -> CoincheckTickerResponse {
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
