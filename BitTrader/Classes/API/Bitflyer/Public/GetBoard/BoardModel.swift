//
//  BoardModel.swift
//  BitTrader
//
//  Created by chako on 2016/10/14.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Himotoki

struct BoardModel {
    let price: Int
    let size: Double
}

extension BoardModel: Decodable {
    
    static func decode(_ e: Extractor) throws -> BoardModel {
        return try self.init(
            price: e <| Bitflyer.APIKey.price.keyPath(),
            size: e <| Bitflyer.APIKey.size.keyPath())
    }
}
