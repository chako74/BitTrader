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
            dic[Bitflyer.APIKey.productCode.rawValue] = productCode.rawValue
        }
        if let count = self.count {
            dic[Bitflyer.APIKey.count.rawValue] = String(count)
        }
        if let before = self.before {
            dic[Bitflyer.APIKey.before.rawValue] = String(before)
        }
        if let after = self.after {
            dic[Bitflyer.APIKey.after.rawValue] = String(after)
        }
        if let childOrderState = self.childOrderState {
            dic[Bitflyer.APIKey.childOrderState.rawValue] = childOrderState.rawValue
        }
        if let parentOrderId = self.parentOrderId {
            dic[Bitflyer.APIKey.parentOrderId.rawValue] = parentOrderId
        }
        
        return dic
    }
}
