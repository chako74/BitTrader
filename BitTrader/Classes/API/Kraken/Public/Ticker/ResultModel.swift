//
//  ResultModel.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/19.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import Himotoki

struct ResultModel {
    let currencyPair: KrakenTickerModel
}

extension ResultModel: Decodable {

    static func decode(_ e: Extractor) throws -> ResultModel {
        return try self.init(
            currencyPair: e <| "XXBTZJPY")
    }
}
