//
//  ZaifTickerResponse.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/18.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import Himotoki

struct ZaifTickerResponse {
    let last: Int
    let bid: Int
    let ask: Int
    let high: Int
    let low: Int
    let volume: Int
    let vwap: Int
}

extension ZaifTickerResponse: Decodable {

    static func decode(_ e: Extractor) throws -> ZaifTickerResponse {
        return try self.init(
            last: e <| "last",
            bid: e <| "bid",
            ask: e <| "ask",
            high: e <| "high",
            low: e <| "low",
            volume: e <| "volume",
            vwap: e <| "vwap"
        )
    }
}
