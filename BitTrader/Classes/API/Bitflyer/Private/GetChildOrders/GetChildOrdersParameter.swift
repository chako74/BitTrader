//
//  GetChildOrdersParameter.swift
//  BitTrader
//
//  Created by chako on 2016/10/10.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

struct GetChildOrdersParameter {
    
    let productCode: ProductCodeType?
    let count: Int?
    let before: Int?
    let after: Int?
    let childOrderState: ChildOrderState?
    let parentOrderId: String?
}

extension GetChildOrdersParameter: BitTraderRequestParameter {
    
    func createParameters() -> [String: String]? {
        
        var dic = [String: String]()
        if let productCode = self.productCode {
            dic[APIKey.productCode.rawValue] = productCode.rawValue
        }
        if let count = self.count {
            dic[APIKey.count.rawValue] = String(count)
        }
        if let before = self.before {
            dic[APIKey.before.rawValue] = String(before)
        }
        if let after = self.after {
            dic[APIKey.after.rawValue] = String(after)
        }
        if let childOrderState = self.childOrderState {
            dic[APIKey.childOrderState.rawValue] = childOrderState.rawValue
        }
        if let parentOrderId = self.parentOrderId {
            dic[APIKey.parentOrderId.rawValue] = parentOrderId
        }
        
        return dic
    }
}
