//
//  BitTraderPrivateRequest.swift
//  BitTrader
//
//  Created by chako on 2016/10/08.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit

protocol BitTraderPrivateRequest: BitTraderRequest {
}

extension BitTraderPrivateRequest {
    
    var headerFields: [String : String] {
        return createHeaders()
    }
    
    private func createHeaders() -> [String: String] {
        
        let secretKey = AppStatus.sharedInstance.apiSecretKey ?? ""
        let timestamp = String(Int(NSDate().timeIntervalSince1970))
        let method = self.method.rawValue
        let path = self.path
        var body = ""
        switch self.method {
        case .get:
            if let queryParameters = self.queryParameters, !queryParameters.isEmpty {
                body = "?\(URLEncodedSerialization.string(from: queryParameters))"
            }
        case .post:
            if let bodyParameters = self.bodyParameters {
                do {
                    switch try bodyParameters.buildEntity() {
                    case .data(let data):
                        body = String(data: data, encoding: String.Encoding.utf8)!
                    default:
                        body = ""
                    }
                } catch {
                    
                }
            }

        default:
            body = ""
        }
        
        let text = timestamp + method + path + body
        let sign = text.hmac(algorithm: .SHA256, key: secretKey)
        
        return ["ACCESS-KEY": AppStatus.sharedInstance.apiKey ?? "",
                "ACCESS-TIMESTAMP": timestamp,
                "ACCESS-SIGN": sign]
    }
}
