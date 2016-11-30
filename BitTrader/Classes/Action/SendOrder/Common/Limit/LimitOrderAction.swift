//
//  LimitOrderAction.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/30.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import ReSwift

enum LimitOrderAction: Action {
    case BidAsk(Enums.BidAsk)
    case Amount(String?)
    case Rate(Double?)
}
