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

    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard (200..<300).contains(urlResponse.statusCode) else {
            guard let dic = object as? [String: Any] else {
                return object
            }
            throw ApiResponseError(status: dic["status"] as? Int ?? 500,
                                   message: dic["error_message"] as? String ?? "",
                                   data: dic["data"])
        }
        return object
    }
}

extension BitTraderRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Self.Response {
        return try decodeValue(object)
    }
}
