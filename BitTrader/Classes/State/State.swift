//
//  State.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/27.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import ReSwift

struct State: StateType {
    var sendOrderState: SendOrderState
    var parentOrderState: ParentOrderState
    var rateModel: RateModel?
}

struct SendOrderState: StateType {
    var productType: Bitflyer.ProductCodeType
    var order: Enums.Order
}

enum ParentOrderState: StateType {
    case simple(HasCondition)
    case ifd(if: HasCondition, done: HasCondition)
    case oco(oco1: HasCondition, oco2: HasCondition)
    case ifdoco(if: HasCondition, oco1: HasCondition, oco2: HasCondition)
}

protocol HasCondition {
    var condition: ChildOrderCondition { get set }
}

//
struct ChildOrderState: HasCondition {
    var condition: ChildOrderCondition
}

enum ChildOrderCondition {
    case limit(bidAsk: Enums.BidAsk, amount: String?, price: Double?)
    case market(bidAsk: Enums.BidAsk, amount: String?)
    case stop(bidAsk: Enums.BidAsk, amount: String?, triggerPrice: Double?)
    case stopLimit(bidAsk: Enums.BidAsk, amount: String?, price: Double?, triggerPrice: Double?)
    case trail(bidAsk: Enums.BidAsk, amount: String?, trailDistance: Double?)
}

extension State {
    init() {
        self.sendOrderState = SendOrderState()
        self.parentOrderState = .simple(ChildOrderState())
    }
}

extension SendOrderState {
    init() {
        self.productType = .fxBtcJpy
        self.order = .simple
    }
}

extension ChildOrderState {
    init() {
        self.condition = .limit(bidAsk: .bid, amount: nil, price: nil)
    }
}

extension ParentOrderState {
    var simple: HasCondition? {
        switch self {
        case .simple(let state):
            return state
        default:
            return nil
        }
    }

    var ifd: (if: HasCondition, done: HasCondition)? {
        switch self {
        case .ifd(let state1, let state2):
            return (if: state1, done: state2)
        default:
            return nil
        }
    }

    var oco: (oco1: HasCondition, oco2: HasCondition)? {
        switch self {
        case .oco(let state1, let state2):
            return (oco1: state1, oco2: state2)
        default:
            return nil
        }
    }

    var ifdoco: (if: HasCondition, oco1: HasCondition, oco2: HasCondition)? {
        switch self {
        case .ifdoco(let state1, let state2, let state3):
            return (if: state1, oco1: state2, oco2: state3)
        default:
            return nil
        }
    }
}

extension ChildOrderCondition {
    var bidAsk: Enums.BidAsk {
        switch self {
        case .limit(let bidAsk, _, _): return bidAsk
        case .market(let bidAsk, _): return bidAsk
        case .stop(let bidAsk, _, _): return bidAsk
        case .stopLimit(let bidAsk, _, _, _): return bidAsk
        case .trail(let bidAsk, _, _): return bidAsk
        }
    }

    var amount: String? {
        switch self {
        case .limit(_, let amount, _): return amount
        case .market(_, let amount): return amount
        case .stop(_, let amount, _): return amount
        case .stopLimit(_, let amount, _, _): return amount
        case .trail(_, let amount, _): return amount
        }
    }

    var price: Double? {
        switch self {
        case .limit(_, _, let price): return price
        case .market(_, _): return nil
        case .stop(_, _, _): return nil
        case .stopLimit(_, _, let price, _): return price
        case .trail(_, _, _): return nil
        }
    }

    var triggerPrice: Double? {
        switch self {
        case .limit(_, _, _): return nil
        case .market(_, _): return nil
        case .stop(_, _, let triggerPrice): return triggerPrice
        case .stopLimit(_, _, _, let triggerPrice): return triggerPrice
        case .trail(_, _, _): return nil
        }
    }

    var offset: Double? {
        switch self {
        case .limit(_, _, _): return nil
        case .market(_, _): return nil
        case .stop(_, _, _): return nil
        case .stopLimit(_, _, _, _): return nil
        case .trail(_, _, let offset): return offset
        }
    }

    var enums: Enums.Condition {
        switch self {
        case .limit: return .limit
        case .market: return .market
        case .stop: return .stop
        case .stopLimit: return .stopLimit
        case .trail: return .trail
        }
    }
}
