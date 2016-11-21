//
//  BitflyerGetChildOrdersParameter.swift
//  BitTrader
//
//  Created by chako on 2016/10/10.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

struct BitflyerGetChildOrdersParameter {
    
    let productCode: Bitflyer.ProductCodeType?
    let count: Int?
    let before: Int?
    let after: Int?
    let childOrderState: Bitflyer.ChildOrderState?
    let parentOrderId: String?
}

extension BitflyerGetChildOrdersParameter: BitTraderRequestParameter {
    
    func createParameters() -> [String: String]? {
        
        var dic = [String: String]()
        if let productCode = self.productCode {
            dic[Bitflyer.ApiKey.productCode.rawValue] = productCode.rawValue
        }
        if let count = self.count {
            dic[Bitflyer.ApiKey.count.rawValue] = String(count)
        }
        if let before = self.before {
            dic[Bitflyer.ApiKey.before.rawValue] = String(before)
        }
        if let after = self.after {
            dic[Bitflyer.ApiKey.after.rawValue] = String(after)
        }
        if let childOrderState = self.childOrderState {
            dic[Bitflyer.ApiKey.childOrderState.rawValue] = childOrderState.rawValue
        }
        if let parentOrderId = self.parentOrderId {
            dic[Bitflyer.ApiKey.parentOrderId.rawValue] = parentOrderId
        }
        
        return dic
    }
}
