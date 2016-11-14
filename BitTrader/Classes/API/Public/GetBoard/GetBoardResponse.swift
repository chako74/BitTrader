//
//  GetBoardResponse.swift
//  BitTrader
//
//  Created by chako on 2016/10/14.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit
import Himotoki

struct GetBoardResponse {
    let midPrice: Int
    let bids: [BoardModel]
    let asks: [BoardModel]
}

extension GetBoardResponse: Decodable {
    
    static func decode(_ e: Extractor) throws -> GetBoardResponse {
        return try self.init(
            midPrice: e <| APIKey.midPrice.keyPath(),
            bids: e <|| APIKey.bids.keyPath(),
            asks: e <|| APIKey.asks.keyPath())
    }
}
