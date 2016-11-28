//
//  SendOrderAction.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/27.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import ReSwift

struct SendOrderAction: Action {
    let bidAsk: Enums.BidAsk
    let rate: String?
}
