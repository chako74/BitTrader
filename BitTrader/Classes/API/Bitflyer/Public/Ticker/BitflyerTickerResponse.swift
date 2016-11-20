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
            last: e <| Bitflyer.APIKey.ltp.keyPath(),
            bid: e <| Bitflyer.APIKey.bestBid.keyPath(),
            ask: e <| Bitflyer.APIKey.bestAsk.keyPath(),
            volume: e <| Bitflyer.APIKey.volume.keyPath(),
            timestamp: e <| Bitflyer.APIKey.timestamp.keyPath()
        )
    }
}
