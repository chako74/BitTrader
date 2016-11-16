//
//  BtcBoxTickerResponse.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/18.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import Himotoki

struct BtcBoxTickerResponse {
    let high: Int
    let low: Int
    let buy: Int
    let sell: Int
    let last: Int
    let vol: Int
}

extension BtcBoxTickerResponse: Decodable {

    static func decode(_ e: Extractor) throws -> BtcBoxTickerResponse {
        return try self.init(
            high: e <| "high",
            low: e <| "low",
            buy: e <| "buy",
            sell: e <| "sell",
            last: e <| "last",
            vol: e <| "vol"
        )
    }
}
