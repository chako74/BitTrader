//
//  GetPositionsParameter.swift
//  BitTrader
//
//  Created by chako on 2016/11/03.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

struct GetPositionsParameter {
    
    let productCode: Bitflyer.ProductCodeType = .fxBtcJpy
}

extension GetPositionsParameter: BitTraderRequestParameter {
    
    func createParameters() -> [String : String]? {
        var dic = [String: String]()
        dic[Bitflyer.APIKey.productCode.rawValue] = productCode.rawValue
        
        return dic
    }
}
