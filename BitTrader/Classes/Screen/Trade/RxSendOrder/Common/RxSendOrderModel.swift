//
//  RxSendOrderModel.swift
//  BitTrader
//
//  Created by chako on 2016/11/26.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation

struct RxSendOrderModel {
    let side: OldEnums.BidAsk
    let size: Double
    let orderType: OldEnums.OrderType
}
