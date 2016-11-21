//
//  BitflyerPositionModel.swift
//  BitTrader
//
//  Created by chako on 2016/11/03.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Himotoki

struct BitflyerPositionModel {
    
    let productCode: String
    let side: Bitflyer.SideType
    let price: Int
    let size: Double
    let commission: Int
    let swapPointAccumulate: Int
    let requireCollateral: Int
    let openDate: String
    let leverage: Int
    let pnl: Int
}

extension BitflyerPositionModel: Decodable {
    
    static func decode(_ e: Extractor) throws -> BitflyerPositionModel {

        return try self.init(
            productCode: e <| Bitflyer.ApiKey.productCode.keyPath(),
            side: Bitflyer.SideType(rawValue:e <| Bitflyer.ApiKey.side.keyPath())!,
            price: e <| Bitflyer.ApiKey.price.keyPath(),
            size: e <| Bitflyer.ApiKey.size.keyPath(),
            commission: e <| Bitflyer.ApiKey.commission.keyPath(),
            swapPointAccumulate: e <| Bitflyer.ApiKey.swapPointAccumulate.keyPath(),
            requireCollateral: e <| Bitflyer.ApiKey.requireCollateral.keyPath(),
            openDate: e <| Bitflyer.ApiKey.openDate.keyPath(),
            leverage: e <| Bitflyer.ApiKey.leverage.keyPath(),
            pnl: e <| Bitflyer.ApiKey.pnl.keyPath())
    }
}
