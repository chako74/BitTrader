//
//  BitflyerGetBoardResponse.swift
//  BitTrader
//
//  Created by chako on 2016/10/14.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit
import Himotoki

struct BitflyerGetBoardResponse {
    let midPrice: Int
    let bids: [BitflyerBoardModel]
    let asks: [BitflyerBoardModel]
}

extension BitflyerGetBoardResponse: Decodable {
    
    static func decode(_ e: Extractor) throws -> BitflyerGetBoardResponse {
        return try self.init(
            midPrice: e <| Bitflyer.APIKey.midPrice.keyPath(),
            bids: e <|| Bitflyer.APIKey.bids.keyPath(),
            asks: e <|| Bitflyer.APIKey.asks.keyPath())
    }
}
