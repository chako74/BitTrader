//
//  Product.swift
//  BitTrader
//
//  Created by chako on 2017/01/09.
//  Copyright © 2017年 Bit Trader. All rights reserved.
//

import RealmSwift

class Product: Object {
    enum ColumnType: String {
        case key
        case enabled
        case sortOrder
    }
    
    dynamic var key =  ""
    dynamic var enabled = true
    dynamic var sortOrder = 0
    
    override static func primaryKey() -> String? {
        return ColumnType.key.rawValue
    }
}
