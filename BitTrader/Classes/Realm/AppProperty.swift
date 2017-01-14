//
//  AppProperty.swift
//  BitTrader
//
//  Created by chako on 2017/01/09.
//  Copyright © 2017年 Bit Trader. All rights reserved.
//

import RealmSwift

class AppProperty: Object {
    
    enum KeyType: String {
        case initialRealm = "InitialRealm"
    }
    
    dynamic var key =  ""
    dynamic var value = ""
    
    override static func primaryKey() -> String? {
        return "key"
    }

}
