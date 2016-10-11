//
//  BalanceModel.swift
//  BitTrader
//
//  Created by chako on 2016/10/08.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Himotoki

struct BalanceModel {
    let currencyCode: String
    let amount: NSNumber
    let available: NSNumber
}

extension BalanceModel: Decodable {
    
    static func decode(_ e: Extractor) throws -> BalanceModel {
        return try self.init(
            currencyCode: e <| "currency_code",
            amount: e <| "amount",
            available: e <| "available")
    }
}
