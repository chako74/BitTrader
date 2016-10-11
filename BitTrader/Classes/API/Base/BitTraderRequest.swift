//
//  BitTraderRequest.swift
//  BitTrader
//
//  Created by chako on 2016/10/07.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit
import Himotoki

protocol BitTraderRequest: Request {
}

extension BitTraderRequest {
    var baseURL: URL {
        return URL(string: "https://api.bitflyer.jp")!        
    }
}

extension BitTraderRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Self.Response {
        return try decodeValue(object)
    }
}
