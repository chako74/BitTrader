//
//  Enums.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation

enum Enums {

    enum BidAsk: String {
        case bid = "売り"
        case ask = "買い"
    }

    enum Order: Int {
        case simple
        case ifd
        case oco
        case ifdoco

        case _count
        static let count = _count.rawValue
        static let values = [Order.simple, .ifd, .oco, .ifdoco]

        var name: String {
            switch self {
            case .simple: return "シンプル"
            case .ifd: return "IFD"
            case .oco: return "OCO"
            case .ifdoco: return "IFD-OCO"
            case ._count: return ""
            }
        }
    }

    enum Place {
        case First
        case Second
        case Third
    }

    enum Condition: Int {
        case limit
        case market
        case stop
        case stopLimit
        case trail

        case _count
        static let count = _count.rawValue
        static let values = [Condition.limit, .market, .stop, .stopLimit, .trail]

        var name: String {
            switch self {
            case .limit: return "指値"
            case .market: return "成行"
            case .stop: return "STOP"
            case .stopLimit: return "STOP-LIMIT"
            case .trail: return "TRAIL"
            case ._count: return ""
            }
        }
    }

    enum OrderType {
        case limit(price: Int)
        case market
        case stop(triggerPrice: Int)
        case stopLimit(price: Int, triggerPrice: Int)
        case trail(trailDistance: Int)

        var name: String {
            switch self {
            case .limit: return "指値"
            case .market: return "成行"
            case .stop: return "STOP"
            case .stopLimit: return "STOP-LIMIT"
            case .trail: return "TRAIL"
            }
        }

        var condition: String {
            switch self {
            case .limit(let price): return "価格:\(price)"
            case .market: return ""
            case .stop(let triggerPrice): return "トリガー価格:\(triggerPrice)"
            case .stopLimit(let price, let triggerPrice): return "価格:\(price)\nトリガー価格:\(triggerPrice)"
            case .trail(let triggerPrice): return "トリガー価格:\(triggerPrice)"
            }
        }
    }
    
}
