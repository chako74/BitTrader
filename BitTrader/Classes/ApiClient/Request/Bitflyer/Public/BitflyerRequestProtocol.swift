//
//  BitflyerRequestProtocol.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/15.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import APIKit

protocol BitflyerRequestProtocol: RequestProtocol {

}

extension BitflyerRequestProtocol {
    var baseURL: URL {
        return URL(string: "https://api.bitflyer.jp")!
    }

    var method: HTTPMethod {
        return .get
    }
}
