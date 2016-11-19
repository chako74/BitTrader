//
//  KrakenTickerModel.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/19.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import Himotoki

struct KrakenTickerModel {
    let a: [String]
    let b: [String]
    let c: [String]
    let v: [String]
    let p: [String]
    let t: [Int]
    let l: [String]
    let h: [String]
    let o: String
}

extension KrakenTickerModel: Decodable {

    static func decode(_ e: Extractor) throws -> KrakenTickerModel {
        return try self.init(
            a: e <|| "a",
            b: e <|| "b",
            c: e <|| "c",
            v: e <|| "v",
            p: e <|| "p",
            t: e <|| "t",
            l: e <|| "l",
            h: e <|| "h",
            o: e <| "o")
    }
}
