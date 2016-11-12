//
//  GetBoardResponse2.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/15.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import Himotoki

struct GetBoardResponse2: BitflyerResponseProtocol {

    let midPrice: Int
    let bids: [BoardModel]
    let asks: [BoardModel]

    static func decode(_ e: Extractor) throws -> GetBoardResponse2 {
        return try self.init(
            midPrice: e <| APIKey.midPrice.keyPath(),
            bids: e <|| APIKey.bids.keyPath(),
            asks: e <|| APIKey.asks.keyPath())
    }
}
