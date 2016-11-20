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
    let orderType: Bitflyer.OrderType
    let side: Bitflyer.SideType
    let size: Double
    let minuteToExpire: Int?
    let timeInForce: Bitflyer.TimeInForceType?
}

extension BitflyerSendChildOrderRequestParameter: BitTraderRequestParameter {
    
    func createParameters() -> [String : String]? {
        
        var dic = [String: String]()
        dic[Bitflyer.APIKey.productCode.rawValue] = productCode.rawValue
        dic[Bitflyer.APIKey.side.rawValue] = side.rawValue
        
        switch orderType {
        case .market:
            dic[Bitflyer.APIKey.childOrderType.rawValue] = Bitflyer.ChildOrderType.market.rawValue
        case let .limit(price):
            dic[Bitflyer.APIKey.childOrderType.rawValue] = Bitflyer.ChildOrderType.limit.rawValue
            dic[Bitflyer.APIKey.price.rawValue] = String(price)
        }
        dic[Bitflyer.APIKey.size.rawValue] = String(size)
        if let minuteToExpire = self.minuteToExpire {
            dic[Bitflyer.APIKey.minuteToExpire.rawValue] = String(minuteToExpire)
        }
        if let timeInForce = self.timeInForce {
            dic[Bitflyer.APIKey.timeInForce.rawValue] = timeInForce.rawValue
        }
                
        return dic
    }
}
