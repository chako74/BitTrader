//
//  BitTraderRequest.swift
//  BitTrader
//
//  Created by chako on 2016/10/07.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit
import Himotoki

public protocol BitTraderRequestParameter {
    func createParameters() -> [String: Any]?
}

protocol BitTraderRequest: ApiKitRequestProtocol {

    associatedtype ParameterType: BitTraderRequestParameter
    
    var requestParameter: ParameterType? { get set }
}

extension BitTraderRequest {
    
    var baseURL: URL {
        return URL(string: "https://api.bitflyer.jp")!
    }
    
    var parameters: Any? {
        if let requestParameter = self.requestParameter {
            return requestParameter.createParameters()
        } else {
            return nil
        }
    }
}

extension BitTraderRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Self.Response {
        return try decodeValue(object)
    }
}
