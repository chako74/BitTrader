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
            last: e <| Bitflyer.ApiKey.ltp.keyPath(),
            bid: e <| Bitflyer.ApiKey.bestBid.keyPath(),
            ask: e <| Bitflyer.ApiKey.bestAsk.keyPath(),
            volume: e <| Bitflyer.ApiKey.volume.keyPath(),
            timestamp: e <| Bitflyer.ApiKey.timestamp.keyPath()
        )
    }
}
