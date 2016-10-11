//
//  GetHealthResponse.swift
//  BitTrader
//
//  Created by chako on 2016/10/07.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Himotoki

struct GetHealthResponse {
    
    enum HealthStatus: String {
        case Normal = "NORMAL"
        case Busy = "BUSY"
        case VeryBusy = "VERY BUSY"
        case Stop = "STOP"
    }

    let status: HealthStatus?
}

extension GetHealthResponse: Decodable {
    
    static func decode(_ e: Extractor) throws -> GetHealthResponse {
        return try self.init(status: HealthStatus(rawValue:e <| "status"))
    }
}
