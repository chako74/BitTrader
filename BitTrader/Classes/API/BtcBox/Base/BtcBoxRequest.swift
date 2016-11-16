//
//  BtcBoxRequest.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/18.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit
import Himotoki

public protocol BtcBoxRequestParameter {
    func createParameters() -> [String: String]?
}

protocol BtcBoxRequest: ApiKitRequestProtocol {
}

extension BtcBoxRequest {

    var baseURL: URL {
        return URL(string: "https://www.btcbox.co.jp")!
    }
}

extension BtcBoxRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Self.Response {
        return try decodeValue(object)
    }
}

extension BtcBoxRequestParameter {
    func createParameters() -> [String: String]? {
        return nil
    }
}
