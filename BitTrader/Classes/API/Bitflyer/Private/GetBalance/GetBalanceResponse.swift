//
//  GetBalanceResponse.swift
//  BitTrader
//
//  Created by chako on 2016/10/08.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit
import Himotoki

struct GetBalanceResponse {
    let balanceModels: [BalanceModel]
}

extension GetBalanceResponse: Decodable {
    
    static func decode(_ e: Extractor) throws -> GetBalanceResponse {
        return try self.init(balanceModels: decodeArray(e.rawValue))
    }
}
