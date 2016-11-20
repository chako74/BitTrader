//
//  BitflyerGetPositionsResponse.swift
//  BitTrader
//
//  Created by chako on 2016/11/03.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit
import Himotoki

struct BitflyerGetPositionsResponse {
    let positionModels: [BitflyerPositionModel]
}

extension BitflyerGetPositionsResponse: Decodable {
    
    static func decode(_ e: Extractor) throws -> BitflyerGetPositionsResponse {
        return try self.init(positionModels: decodeArray(e.rawValue))
    }
}
