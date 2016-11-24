//
//  CancelChildOrderParameter.swift
//  BitTrader
//
//  Created by chako on 2016/11/20.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation

struct BitflyerCancelChildOrderParameter {
    
    let cancelChildOrderType: Bitflyer.CancelChildOrderType
}

extension BitflyerCancelChildOrderParameter: BitTraderRequestParameter {
    
    func createParameters() -> [String : Any]? {
        
        var dic = [String: String]()
        
        switch cancelChildOrderType {
        case let .orderId(productCode, orderId):
            dic[Bitflyer.ApiKey.productCode.rawValue] = productCode.rawValue
            dic[Bitflyer.ApiKey.childOrderId.rawValue] = orderId
            
        case let .acceptanceId(productCode, acceptanceId):
            dic[Bitflyer.ApiKey.productCode.rawValue] = productCode.rawValue
            dic[Bitflyer.ApiKey.childOrderAcceptanceId.rawValue] = acceptanceId
        }
        
        return dic
    }
}
