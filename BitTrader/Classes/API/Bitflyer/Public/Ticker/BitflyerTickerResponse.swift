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
    
    let productCode: Bitflyer.ProductCodeType
    let timestamp: String
    let tickId: Int
    let bestBid: Int
    let bestAsk: Int
    let bestBidSize: Int
    let bestAskSize: Int
    let totalBidDepth: Double
    let totalAskDepth: Double
    let ltp: Int
    let volume: Double
    let volumeByProduct: Double
}

extension BitflyerTickerResponse: Decodable {

    static func decode(_ e: Extractor) throws -> BitflyerTickerResponse {
        return try self.init(
            productCode: Bitflyer.ProductCodeType(rawValue: e <| Bitflyer.ApiKey.productCode.keyPath())!,
            timestamp: e <| Bitflyer.ApiKey.timestamp.keyPath(),
            tickId: e <| Bitflyer.ApiKey.tickId.keyPath(),
            bestBid: e <| Bitflyer.ApiKey.bestBid.keyPath(),
            bestAsk: e <| Bitflyer.ApiKey.bestAsk.keyPath(),
            bestBidSize: e <| Bitflyer.ApiKey.bestBidSize.keyPath(),
            bestAskSize: e <| Bitflyer.ApiKey.bestAskSize.keyPath(),
            totalBidDepth: e <| Bitflyer.ApiKey.totalBidDepth.keyPath(),
            totalAskDepth: e <| Bitflyer.ApiKey.totalAskDepth.keyPath(),
            ltp: e <| Bitflyer.ApiKey.ltp.keyPath(),
            volume: e <| Bitflyer.ApiKey.volume.keyPath(),
            volumeByProduct: e <| Bitflyer.ApiKey.volumeByProduct.keyPath())
    }
}
