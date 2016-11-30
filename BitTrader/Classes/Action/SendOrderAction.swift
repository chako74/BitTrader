//
//  SendOrderAction.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/27.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import ReSwift

enum SendOrderAction: Action {
    case ProductCodeType(Bitflyer.ProductCodeType)
    case Order(Enums.Order)
    case Condition(Enums.Condition)
    case BidAsk(Enums.BidAsk)
    case Response(BitflyerTickerResponse?)
}
