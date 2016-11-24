//
//  BitflyerSendChildOrderRequestParameter.swift
//  BitTrader
//
//  Created by chako on 2016/11/20.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation

struct BitflyerSendChildOrderRequestParameter {
    
    let productCode: Bitflyer.ProductCodeType
    let orderType: Bitflyer.NomalOrderType
    let side: Bitflyer.SideType
    let size: Double
    let minuteToExpire: Int?
    let timeInForce: Bitflyer.TimeInForceType?
}

extension BitflyerSendChildOrderRequestParameter: BitTraderRequestParameter {
    
    func createParameters() -> [String : Any]? {
        
        var dic = [String: Any]()
        dic[Bitflyer.ApiKey.productCode.rawValue] = productCode.rawValue
        dic[Bitflyer.ApiKey.side.rawValue] = side.rawValue
        
        switch orderType {
        case .market:
            dic[Bitflyer.ApiKey.childOrderType.rawValue] = Bitflyer.ChildOrderType.market.rawValue
        case let .limit(price):
            dic[Bitflyer.ApiKey.childOrderType.rawValue] = Bitflyer.ChildOrderType.limit.rawValue
            dic[Bitflyer.ApiKey.price.rawValue] = price
        }
        dic[Bitflyer.ApiKey.size.rawValue] = size
        if let minuteToExpire = self.minuteToExpire {
            dic[Bitflyer.ApiKey.minuteToExpire.rawValue] = String(minuteToExpire)
        }
        if let timeInForce = self.timeInForce {
            dic[Bitflyer.ApiKey.timeInForce.rawValue] = timeInForce.rawValue
        }
                
        return dic
    }
}
