//
//  BitflyerGetChildOrdersResponse.swift
//  BitTrader
//
//  Created by chako on 2016/10/10.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit
import Himotoki

struct BitflyerGetChildOrdersResponse {
    let orderModels: [BitflyerOrderModel]
}

extension BitflyerGetChildOrdersResponse: Decodable {
    
    static func decode(_ e: Extractor) throws -> BitflyerGetChildOrdersResponse {
        return try self.init(orderModels: decodeArray(e.rawValue))
    }
}
