//
//  BitflyerSendChildOrderResponse.swift
//  BitTrader
//
//  Created by chako on 2016/11/20.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit
import Himotoki

struct BitflyerSendChildOrderResponse {
    let childOrderAcceptanceId: String
}

extension BitflyerSendChildOrderResponse: Decodable {
    
    static func decode(_ e: Extractor) throws -> BitflyerSendChildOrderResponse {
        return try self.init(
            childOrderAcceptanceId: e <| Bitflyer.ApiKey.childOrderAcceptanceId.keyPath())
    }
}
