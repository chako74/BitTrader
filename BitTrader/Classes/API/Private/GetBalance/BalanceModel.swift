//
//  BalanceModel.swift
//  BitTrader
//
//  Created by chako on 2016/10/08.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Himotoki

struct BalanceModel {
    let currencyCode: CurrencyCode
    let amount: Double
    let available: Double
}

extension BalanceModel: Decodable {
    
    static func decode(_ e: Extractor) throws -> BalanceModel {
        return try self.init(
            currencyCode: CurrencyCode(rawValue: e <| APIKey.currencyCode.keyPath())!,
            amount: e <| APIKey.amount.keyPath(),
            available: e <| APIKey.available.keyPath())
    }
}
