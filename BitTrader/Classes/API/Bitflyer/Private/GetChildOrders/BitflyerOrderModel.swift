//
//  BitflyerOrderModel.swift
//  BitTrader
//
//  Created by chako on 2016/10/10.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Himotoki

struct BitflyerOrderModel {
    let id: Int
    let childOrderId: String
    let productCode: Bitflyer.ProductCodeType
    let side: Bitflyer.SideType
    let childOrderType: Bitflyer.ChildOrderType
    let price: Int
    let averagePrice: Int
    let size: Double
    let childOrderState: Bitflyer.ChildOrderState
    let expireDate: String
    let childOrderDate: String
    let childOrderAcceptanceId: String
    let outstandingSize: Int
    let cancelSize: Int
    let executedSize: Int
    let totalCommission: Int
}

extension BitflyerOrderModel: Decodable {
    
    static func decode(_ e: Extractor) throws -> BitflyerOrderModel {
        return try self.init(
            id: e <| Bitflyer.ApiKey.id.keyPath(),
            childOrderId: e <| Bitflyer.ApiKey.childOrderId.keyPath(),
            productCode: Bitflyer.ProductCodeType(rawValue: e <| Bitflyer.ApiKey.productCode.keyPath())!,
            side: Bitflyer.SideType(rawValue: e <| Bitflyer.ApiKey.side.keyPath())!,
            childOrderType: Bitflyer.ChildOrderType(rawValue: e <| Bitflyer.ApiKey.childOrderType.keyPath())!,
            price: e <| Bitflyer.ApiKey.price.keyPath(),
            averagePrice: e <| Bitflyer.ApiKey.averagePrice.keyPath(),
            size: e <| Bitflyer.ApiKey.size.keyPath(),
            childOrderState: Bitflyer.ChildOrderState(rawValue: e <| Bitflyer.ApiKey.childOrderState.keyPath())!,
            expireDate: e <| Bitflyer.ApiKey.expireDate.keyPath(),
            childOrderDate: e <| Bitflyer.ApiKey.childOrderDate.keyPath(),
            childOrderAcceptanceId: e <| Bitflyer.ApiKey.childOrderAcceptanceId.keyPath(),
            outstandingSize: e <| Bitflyer.ApiKey.outstandingSize.keyPath(),
            cancelSize: e <| Bitflyer.ApiKey.cancelSize.keyPath(),
            executedSize: e <| Bitflyer.ApiKey.executedSize.keyPath(),
            totalCommission: e <| Bitflyer.ApiKey.totalCommission.keyPath())
    }
}
