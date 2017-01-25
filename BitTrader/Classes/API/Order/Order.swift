//
//  Order.swift
//  BitTrader
//
//  Created by chako on 2017/01/16.
//  Copyright © 2017年 Bit Trader. All rights reserved.
//

struct Order {
    
    let productType: Enums.ProductType
    let tradeType: Enums.TradeType
    let bidAsk: Enums.BidAskType
    let orderId: String
    let relationOrderId: String
}
