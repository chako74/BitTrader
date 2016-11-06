//
//  GetPositionsResponse.swift
//  BitTrader
//
//  Created by chako on 2016/11/03.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit
import Himotoki

struct GetPositionsResponse {
    let positionModels: [PositionModel]
}

extension GetPositionsResponse: Decodable {
    
    static func decode(_ e: Extractor) throws -> GetPositionsResponse {
        return try self.init(positionModels: decodeArray(e.rawValue))
    }
}
