//
//  BoardModel.swift
//  BitTrader
//
//  Created by chako on 2016/10/14.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Himotoki

struct BitflyerBoardModel {
    let price: Int
    let size: Double
}

extension BitflyerBoardModel: Decodable {
    
    static func decode(_ e: Extractor) throws -> BitflyerBoardModel {
        return try self.init(
            price: e <| Bitflyer.ApiKey.price.keyPath(),
            size: e <| Bitflyer.ApiKey.size.keyPath())
    }
}
