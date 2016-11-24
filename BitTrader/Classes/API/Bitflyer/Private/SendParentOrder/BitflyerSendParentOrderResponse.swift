//
//  BitflyerSendParentOrderResponse.swift
//  BitTrader
//
//  Created by chako on 2016/11/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit
import Himotoki

struct BitflyerSendParentOrderResponse {
    let parentOrderAcceptanceId: String
}

extension BitflyerSendParentOrderResponse: Decodable {
    
    static func decode(_ e: Extractor) throws -> BitflyerSendParentOrderResponse {
        
        return try self.init(parentOrderAcceptanceId: e <| Bitflyer.ApiKey.parentOrderAcceptanceId.keyPath())
    }
}
