//
//  PositionModel.swift
//  BitTrader
//
//  Created by chako on 2016/11/03.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Himotoki

struct PositionModel {
    
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

extension PositionModel: Decodable {
    
    static func decode(_ e: Extractor) throws -> PositionModel {

        return try self.init(
            productCode: e <| Bitflyer.APIKey.productCode.keyPath(),
            side: Bitflyer.SideType(rawValue:e <| Bitflyer.APIKey.side.keyPath())!,
            price: e <| Bitflyer.APIKey.price.keyPath(),
            size: e <| Bitflyer.APIKey.size.keyPath(),
            commission: e <| Bitflyer.APIKey.commission.keyPath(),
            swapPointAccumulate: e <| Bitflyer.APIKey.swapPointAccumulate.keyPath(),
            requireCollateral: e <| Bitflyer.APIKey.requireCollateral.keyPath(),
            openDate: e <| Bitflyer.APIKey.openDate.keyPath(),
            leverage: e <| Bitflyer.APIKey.leverage.keyPath(),
            pnl: e <| Bitflyer.APIKey.pnl.keyPath())
    }
}
