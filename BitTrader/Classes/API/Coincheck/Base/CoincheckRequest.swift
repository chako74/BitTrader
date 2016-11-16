//
//  CoincheckRequest.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/17.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit
import Himotoki

public protocol CoincheckRequestParameter {
    func createParameters() -> [String: String]?
}

protocol CoincheckRequest: ApiKitRequestProtocol {
}

extension CoincheckRequest {

    var baseURL: URL {
        return URL(string: "https://coincheck.com")!
    }
}

extension CoincheckRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Self.Response {
        return try decodeValue(object)
    }
}

extension CoincheckRequestParameter {
    func createParameters() -> [String: String]? {
        return nil
    }
}
