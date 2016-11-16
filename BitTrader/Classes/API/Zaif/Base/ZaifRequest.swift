//
//  ZaifRequest.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/18.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit
import Himotoki

public protocol ZaifRequestParameter {
    func createParameters() -> [String: String]?
}

protocol ZaifRequest: ApiKitRequestProtocol {
}

extension ZaifRequest {

    var baseURL: URL {
        return URL(string: "https://api.zaif.jp")!
    }
}

extension ZaifRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Self.Response {
        return try decodeValue(object)
    }
}

extension ZaifRequestParameter {
    func createParameters() -> [String: String]? {
        return nil
    }
}
