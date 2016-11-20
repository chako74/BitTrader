//
//  CancelChildOrderParameter.swift
//  BitTrader
//
//  Created by chako on 2016/11/20.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation

struct CancelChildOrderParameter {
    
    let cancelChildOrderType: Bitflyer.CancelChildOrderType
}

extension CancelChildOrderParameter: BitTraderRequestParameter {
    
    func createParameters() -> [String : String]? {
        
        var dic = [String: String]()
        
        switch cancelChildOrderType {
        case let .orderId(productCode, orderId):
            dic[Bitflyer.APIKey.productCode.rawValue] = productCode.rawValue
            dic[Bitflyer.APIKey.childOrderId.rawValue] = orderId
            
        case let .acceptanceId(productCode, acceptanceId):
            dic[Bitflyer.APIKey.productCode.rawValue] = productCode.rawValue
            dic[Bitflyer.APIKey.childOrderAcceptanceId.rawValue] = acceptanceId
        }
        
        return dic
    }
}
