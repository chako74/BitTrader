//
//  CoinchekRequestProtocol.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/14.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import APIKit

protocol CoinchekRequestProtocol: RequestProtocol {

}

extension CoinchekRequestProtocol {
    var baseURL: URL {
        return URL(string: "https://coincheck.com")!
    }

    var method: HTTPMethod {
        return .get
    }
}
