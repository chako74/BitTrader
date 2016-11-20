//
//  CancelChildOrderResponse.swift
//  BitTrader
//
//  Created by chako on 2016/11/20.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit
import Himotoki

struct BitflyerCancelChildOrderResponse {
}

extension BitflyerCancelChildOrderResponse: Decodable {
    static func decode(_ e: Extractor) throws -> BitflyerCancelChildOrderResponse {
        return self.init()
    }
}
