//
//  RequestProtocol.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/14.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import APIKit
import Himotoki

protocol RequestProtocol: Request {

}

extension RequestProtocol where Response: ResponseProtocol {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try decodeValue(object)
    }
}
