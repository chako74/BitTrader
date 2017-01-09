//
//  BitflyerSendParentOrderParameter.swift
//  BitTrader
//
//  Created by chako on 2016/11/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation

struct BitflyerSendParentOrderParameter {
    
    let orderMethod: Bitflyer.OrderMethodType
    let minuteToExpire: Int?
    let timeInForce: Bitflyer.TimeInForceType?
    let parameters: [SendOrderModel]
}

extension BitflyerSendParentOrderParameter: BitTraderRequestParameter {
    
    func createParameters() -> [String : Any]? {
        
        var dic = [String: Any]()
        
        dic[Bitflyer.ApiKey.orderMethod.rawValue] = orderMethod.rawValue
        
        if let minuteToExpire = minuteToExpire {
            dic[Bitflyer.ApiKey.minuteToExpire.rawValue] = minuteToExpire
        }
        if let timeInForce = timeInForce {
            dic[Bitflyer.ApiKey.timeInForce.rawValue] = timeInForce
        }
        
        var items = [[String: Any]]()
        for model in parameters {
            if let childParameters = model.createParameters() {
                items.append(childParameters)
            }
        }
        dic[Bitflyer.ApiKey.parameters.rawValue] = items
        
        return dic
    }
}
