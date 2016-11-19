//
//  KrakenTickerResponse.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/18.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import Himotoki

struct KrakenTickerResponse {
    let error: [String]?
    let result: ResultModel?
}

extension KrakenTickerResponse: Decodable {

    static func decode(_ e: Extractor) throws -> KrakenTickerResponse {
        return try self.init(
            error: e <||? "error",
            result: e <|? "result")
    }
}
