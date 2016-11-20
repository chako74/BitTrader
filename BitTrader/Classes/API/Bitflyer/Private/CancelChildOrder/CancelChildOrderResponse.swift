//
//  CancelChildOrderResponse.swift
//  BitTrader
//
//  Created by chako on 2016/11/20.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit
import Himotoki

struct CancelChildOrderResponse {
}

extension CancelChildOrderResponse: Decodable {
    static func decode(_ e: Extractor) throws -> CancelChildOrderResponse {
        return self.init()
    }
}
