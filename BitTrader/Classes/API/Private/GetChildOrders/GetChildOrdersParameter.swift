//
//  GetChildOrdersParameter.swift
//  BitTrader
//
//  Created by chako on 2016/10/10.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

struct GetChildOrdersParameter {
    
    enum ChildOrderState: String {
        case active = "ACTIVE"
        case completed = "COMPLETED"
        case canceled = "CANCELED"
        case expired = "EXPIRED"
        case rejected = "REJECTED"
    }
    
    let productCode: String?
    let count: Int?
    let before: Int?
    let after: Int?
    let childOrderState: ChildOrderState?
    let parentOrderId: String?
}

extension GetChildOrdersParameter: BitTraderRequestParameter {
    
    func createParameters() -> [String: String]? {
        
        // TODO: パラメータ作成
        var dic = [String: String]()
        if let productCode = self.productCode {
            dic["product_code"] = productCode
        }
        
        return dic
    }
}
