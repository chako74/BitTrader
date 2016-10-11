//
//  BitTraderPrivateAPI.swift
//  BitTrader
//
//  Created by chako on 2016/10/09.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

final class BitTraderPrivateAPI {
    
    func sendGetBalanceRequest() {
        let request = GetBalanceRequest()
        Session.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func sendGetChildOrdersRequest() {
        let param = GetChildOrdersParameter(
            productCode: "BTC_JPY",
            count: nil,
            before: nil,
            after: nil,
            childOrderState: nil,
            parentOrderId: nil)
        let request = GetChildOrdersRequest(requestParameter: param)
        Session.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
