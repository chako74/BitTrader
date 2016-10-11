//
//  GetChildOrdersParameter.swift
//  BitTrader
//
//  Created by chako on 2016/10/10.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

struct GetChildOrdersParameter {
    
    enum ChildOrderState: String {
        case Active = "ACTIVE"
        case Completed = "COMPLETED"
        case Canceled = "CANCELED"
        case Expired = "EXPIRED"
        case Rejected = "REJECTED"
    }
    
    let productCode: String?
    let count: Int?
    let before: Int?
    let after: Int?
    let childOrderState: ChildOrderState?
    let parentOrderId: String?
    
    func createParameters() -> [String: String]? {
        
        var dic = [String: String]()
        if let productCode = self.productCode {
            dic["product_code"] = productCode
        }
        
        return dic
    }
}
