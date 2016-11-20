//
//  BitflyerApiEnum.swift
//  BitTrader
//
//  Created by chako on 2016/10/14.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Himotoki

enum Bitflyer {
    enum ProductCodeType: String {
        case btcjpy = "BTC_JPY"
        case fxBtcJpy = "FX_BTC_JPY"
        case ethBtc = "ETHBTC"
    }
    
    enum SideType: String {
        case buy = "BUY"
        case sell = "SELL"
    }
    
    enum ChildOrderState: String {
        case active = "ACTIVE"
        case completed = "COMPLETED"
        case canceled = "CANCELED"
        case expired = "EXPIRED"
        case rejected = "REJECTED"
    }
    
    enum ChildOrderType: String {
        case market = "MARKET"
        case limit = "LIMIT"
    }
    
    enum CurrencyCode: String {
        case jpy = "JPY"
        case btc = "BTC"
        case eth = "ETH"
    }
    
    enum HealthStatus: String {
        case normal = "NORMAL"
        case busy = "BUSY"
        case veryBusy = "VERY BUSY"
        case stop = "STOP"
    }
    
    enum TimeInForceType: String {
        case gtc = "GTC"
        case ioc = "IOC"
        case fok = "FOK"
    }
    
    enum ApiKey: String {
        case productCode = "product_code"
        case side = "side"
        case price = "price"
        case size = "size"
        case commission = "commission"
        case swapPointAccumulate = "swap_point_accumulate"
        case requireCollateral = "require_collateral"
        case openDate = "open_date"
        case leverage = "leverage"
        case pnl = "pnl"
        case count = "count"
        case before = "before"
        case after = "after"
        case childOrderState = "child_order_state"
        case parentOrderId = "parent_order_id"
        case id = "id"
        case childOrderId = "child_order_id"
        case childOrderType = "child_order_type"
        case averagePrice = "average_price"
        case expireDate = "expire_date"
        case childOrderDate = "child_order_date"
        case childOrderAcceptanceId = "child_order_acceptance_id"
        case outstandingSize = "outstanding_size"
        case cancelSize = "cancel_size"
        case executedSize = "executed_size"
        case totalCommission = "total_commission"
        case midPrice = "mid_price"
        case bids = "bids"
        case asks = "asks"
        case status = "status"
        case currencyCode = "currency_code"
        case amount = "amount"
        case available = "available"
        case ltp = "ltp"
        case bestBid = "best_bid"
        case bestAsk =  "best_ask"
        case volume = "volume"
        case timestamp = "timestamp"
        case minuteToExpire = "minute_to_expire"
        case timeInForce = "time_in_force"
        case tickId = "tick_id"
        case bestBidSize = "best_bid_size"
        case bestAskSize = "best_ask_size"
        case totalBidDepth = "total_bid_depth"
        case totalAskDepth = "total_ask_depth"
        case volumeByProduct = "volume_by_product"
        
        func keyPath() -> KeyPath {
            return KeyPath.init(rawValue)
        }
    }
    
    enum OrderType {
        case market
        case limit(price: Int)
    }

    enum CancelChildOrderType {
        case orderId(productCode: ProductCodeType, orderId: String)
        case acceptanceId(productCode: ProductCodeType, acceptancedId: String)
    }
}