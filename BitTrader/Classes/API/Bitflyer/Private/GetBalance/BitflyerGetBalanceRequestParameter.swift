//
//  GetBalanceRequestParameter.swift
//  BitTrader
//
//  Created by chako on 2016/11/20.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

struct BitflyerGetBalanceRequestParameter {
}

extension BitflyerGetBalanceRequestParameter: BitTraderRequestParameter {
    
    func createParameters() -> [String : Any]? {
        return nil
    }
}
