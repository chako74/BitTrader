//
//  BitTraderPublicAPI.swift
//  BitTrader
//
//  Created by chako on 2016/10/07.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

final class BitTraderPublicAPI {
    
    // TODO: 実装試し
    func sendGetHealthRequest() {
        let request = GetHealthRequest()
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
