//
//  BitflyerTickerRequestParameter.swift
//  BitTrader
//
//  Created by chako on 2016/11/20.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

struct BitflyerTickerRequestParameter {
    let productCode: Bitflyer.ProductCodeType
}

extension BitflyerTickerRequestParameter: BitTraderRequestParameter {
    
    func createParameters() -> [String : Any]? {
        
        var dic = [String: Any]()
        dic[Bitflyer.ApiKey.productCode.rawValue] = productCode.rawValue
        
        return dic
    }
}
