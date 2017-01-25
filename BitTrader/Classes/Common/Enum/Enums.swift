//
//  Enums.swift
//  BitTrader
//
//  Created by chako on 2017/01/16.
//  Copyright © 2017年 Bit Trader. All rights reserved.
//

import Foundation

enum Enums {
    
    enum ProductType: String {
        case bitflyerBTC = "Bitflyer BTC"
        case bitflyerFxBTC = "Bitflyer FX BTC"
        case btcboxBTC = "BTCBOX BTC"
        case coinCheckBTC = "CoinCheck BTC"
        case krakenBTC = "Kraken BTC"
        case zaifBTC = "Zaif BTC"
        
        static let values = [ProductType.bitflyerBTC,
                             .bitflyerFxBTC,
                             .btcboxBTC,
                             .coinCheckBTC,
                             .krakenBTC,
                             .zaifBTC]
    }
    
    enum BidAskType: String {
        case bid = "売"
        case ask = "買"
    }
    
    enum TradeType: String {
        case new = "新規"
        case settlement = "決済"
    }

    enum OrderType: String {
        case normal = "通常"
        case oco = "OCO"
        case ifd = "IFD"
        case ifdoco = "IFDOCO"
    }
    
    enum ConditionType: String {
        case market = "成行"
        case limit = "指値"
        case stop = "逆指値"
        case stopLimit = "ストップリミット"
        case trail = "トレール"
    }
}
