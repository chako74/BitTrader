//
//  KrakenRequest.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/18.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit
import Himotoki

public protocol KrakenRequestParameter {
    func createParameters() -> [String: String]?
}

protocol KrakenRequest: ApiKitRequestProtocol {
}

extension KrakenRequest {

    var baseURL: URL {
        return URL(string: "https://api.kraken.com")!
    }
}

extension KrakenRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Self.Response {
        return try decodeValue(object)
    }
}

extension KrakenRequestParameter {
    func createParameters() -> [String: String]? {
        return nil
    }
}
