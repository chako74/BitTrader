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
    let side: SideType
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
            productCode: e <| APIKey.productCode.keyPath(),
            side: SideType(rawValue:e <| APIKey.side.keyPath())!,
            price: e <| APIKey.price.keyPath(),
            size: e <| APIKey.size.keyPath(),
            commission: e <| APIKey.commission.keyPath(),
            swapPointAccumulate: e <| APIKey.swapPointAccumulate.keyPath(),
            requireCollateral: e <| APIKey.requireCollateral.keyPath(),
            openDate: e <| APIKey.openDate.keyPath(),
            leverage: e <| APIKey.leverage.keyPath(),
            pnl: e <| APIKey.pnl.keyPath())
    }
}
