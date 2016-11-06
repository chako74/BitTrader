//
//  APIEnum.swift
//  BitTrader
//
//  Created by chako on 2016/10/14.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Himotoki

enum ProductCodeType: String {
    case btcjpy = "BTC_JPY"
    case fxBtcJpy = "FX_BTC_JPY"
    case ethBtc = "ETHBTC"
}

enum SideType: String {
    case buy = "BUY"
    case sell = "SELL"
}

enum APIKey: String {
    case productCode = "product_code"
    case side = "side"
    case price = "price"
    case size = "size"
    case commission = "commission"
    case swapPointAccumulate = "swap_point_accumulate"
    case requireCollateral = "require_collateral"
    case openDate = "open_date"
    case leverage = "leverage"
    case pnl = "pnl"
    
    func keyPath() -> KeyPath {
        return KeyPath.init(rawValue)
    }
}

enum DateFormat: String {
    case iso8601 = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    case openPosition = "MM/dd HH:mm:ss"
}
