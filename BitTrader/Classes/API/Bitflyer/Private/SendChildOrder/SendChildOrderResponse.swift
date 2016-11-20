//
//  SendChildOrderResponse.swift
//  BitTrader
//
//  Created by chako on 2016/11/20.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit
import Himotoki

struct SendChildOrderResponse {
    let childOrderAcceptanceId: String
}

extension SendChildOrderResponse: Decodable {
    
    static func decode(_ e: Extractor) throws -> SendChildOrderResponse {
        return try self.init(
            childOrderAcceptanceId: e <| Bitflyer.APIKey.childOrderAcceptanceId.keyPath())
    }
}
