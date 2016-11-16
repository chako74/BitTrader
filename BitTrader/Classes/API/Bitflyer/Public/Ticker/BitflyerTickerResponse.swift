//
//  BitflyerTickerResponse.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/18.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import Himotoki

struct BitflyerTickerResponse {
    let last: Int
    let bid: Int
    let ask: Int
    let volume: Int
    let timestamp: String
}

extension BitflyerTickerResponse: Decodable {

    static func decode(_ e: Extractor) throws -> BitflyerTickerResponse {
        return try self.init(
            last: e <| "ltp",
            bid: e <| "best_bid",
            ask: e <| "best_ask",
            volume: e <| "volume",
            timestamp: e <| "timestamp"
        )
    }
}
