//
//  LimitOrderState.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/30.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import ReSwift

struct LimitOrderState: StateType {
    var bidAsk: Enums.BidAsk
    var amount: String?
    var rate: Double?
}
