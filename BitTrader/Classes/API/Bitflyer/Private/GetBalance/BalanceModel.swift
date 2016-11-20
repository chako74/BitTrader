//
//  BalanceModel.swift
//  BitTrader
//
//  Created by chako on 2016/10/08.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Himotoki

struct BalanceModel {
    let currencyCode: Bitflyer.CurrencyCode
    let amount: Double
    let available: Double
}

extension BalanceModel: Decodable {
    
    static func decode(_ e: Extractor) throws -> BalanceModel {
        return try self.init(
            currencyCode: Bitflyer.CurrencyCode(rawValue: e <| Bitflyer.APIKey.currencyCode.keyPath())!,
            amount: e <| Bitflyer.APIKey.amount.keyPath(),
            available: e <| Bitflyer.APIKey.available.keyPath())
    }
}
