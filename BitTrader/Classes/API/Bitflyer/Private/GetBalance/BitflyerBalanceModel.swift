//
//  BalanceModel.swift
//  BitTrader
//
//  Created by chako on 2016/10/08.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Himotoki

struct BitflyerBalanceModel {
    let currencyCode: Bitflyer.CurrencyCode
    let amount: Double
    let available: Double
}

extension BitflyerBalanceModel: Decodable {
    
    static func decode(_ e: Extractor) throws -> BitflyerBalanceModel {
        return try self.init(
            currencyCode: Bitflyer.CurrencyCode(rawValue: e <| Bitflyer.APIKey.currencyCode.keyPath())!,
            amount: e <| Bitflyer.APIKey.amount.keyPath(),
            available: e <| Bitflyer.APIKey.available.keyPath())
    }
}
