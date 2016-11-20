//
//  GetHealthResponse.swift
//  BitTrader
//
//  Created by chako on 2016/10/07.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Himotoki

struct GetHealthResponse {
    
    let status: Bitflyer.HealthStatus?
}

extension GetHealthResponse: Decodable {
    
    static func decode(_ e: Extractor) throws -> GetHealthResponse {
        return try self.init(status: Bitflyer.HealthStatus(rawValue:e <| Bitflyer.APIKey.status.keyPath()))
    }
}
