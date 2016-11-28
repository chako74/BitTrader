//
//  RxSendOrderViewModel.swift
//  BitTrader
//
//  Created by chako on 2016/11/26.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation

struct RxSendOrderViewModel {
    let side: Enums.BidAsk
    let size: Double
    let orderType: Enums.OrderType
}
