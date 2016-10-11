//
//  GetChildOrdersResponse.swift
//  BitTrader
//
//  Created by chako on 2016/10/10.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit
import Himotoki

struct GetChildOrdersResponse {
    let orderModels: [OrderModel]
}

extension GetChildOrdersResponse: Decodable {
    
    static func decode(_ e: Extractor) throws -> GetChildOrdersResponse {
        return try self.init(orderModels: decodeArray(e.rawValue))
    }
}
