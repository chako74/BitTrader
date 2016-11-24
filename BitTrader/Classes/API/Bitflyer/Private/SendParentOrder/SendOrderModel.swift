//
//  SendOrder.swift
//  BitTrader
//
//  Created by chako on 2016/11/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation

struct SendOrderModel {
    let productCode: Bitflyer.ProductCodeType
    let side: Bitflyer.SideType
    let size: Int
    let orderType: Bitflyer.SpecialOrderType
}

extension SendOrderModel: BitTraderRequestParameter {
    
    func createParameters() -> [String : Any]? {
        
        var dic = [String: Any]()
        
        dic[Bitflyer.ApiKey.productCode.rawValue] = productCode.rawValue
        
        switch orderType {
        case .market:
            dic[Bitflyer.ApiKey.conditionType.rawValue] = Bitflyer.ConditionType.market.rawValue
            
        case let .limit(price):
            dic[Bitflyer.ApiKey.conditionType.rawValue] = Bitflyer.ConditionType.limit.rawValue
            dic[Bitflyer.ApiKey.price.rawValue] = price
            
        case let .stop(price):
            dic[Bitflyer.ApiKey.conditionType.rawValue] = Bitflyer.ConditionType.stop.rawValue
            dic[Bitflyer.ApiKey.price.rawValue] = price
            
        case let .stopLimit(price, triggerPrice):
            dic[Bitflyer.ApiKey.conditionType.rawValue] = Bitflyer.ConditionType.stopLimit.rawValue
            dic[Bitflyer.ApiKey.price.rawValue] = price
            dic[Bitflyer.ApiKey.triggerPrice.rawValue] = triggerPrice
            
        case let .trail(trailDistance):
            dic[Bitflyer.ApiKey.conditionType.rawValue] = Bitflyer.ConditionType.trail.rawValue
            dic[Bitflyer.ApiKey.offset.rawValue] = trailDistance
        }
        dic[Bitflyer.ApiKey.side.rawValue] = side.rawValue
        dic[Bitflyer.ApiKey.side.rawValue] = size
        
        return dic
    }
}
