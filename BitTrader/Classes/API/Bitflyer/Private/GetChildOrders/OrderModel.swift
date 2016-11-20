//
//  OrderModel.swift
//  BitTrader
//
//  Created by chako on 2016/10/10.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Himotoki

struct OrderModel {
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

extension OrderModel: Decodable {
    
    static func decode(_ e: Extractor) throws -> OrderModel {
        return try self.init(
            id: e <| Bitflyer.APIKey.id.keyPath(),
            childOrderId: e <| Bitflyer.APIKey.childOrderId.keyPath(),
            productCode: Bitflyer.ProductCodeType(rawValue: e <| Bitflyer.APIKey.productCode.keyPath())!,
            side: Bitflyer.SideType(rawValue: e <| Bitflyer.APIKey.side.keyPath())!,
            childOrderType: Bitflyer.ChildOrderType(rawValue: e <| Bitflyer.APIKey.childOrderType.keyPath())!,
            price: e <| Bitflyer.APIKey.price.keyPath(),
            averagePrice: e <| Bitflyer.APIKey.averagePrice.keyPath(),
            size: e <| Bitflyer.APIKey.size.keyPath(),
            childOrderState: Bitflyer.ChildOrderState(rawValue: e <| Bitflyer.APIKey.childOrderState.keyPath())!,
            expireDate: e <| Bitflyer.APIKey.expireDate.keyPath(),
            childOrderDate: e <| Bitflyer.APIKey.childOrderDate.keyPath(),
            childOrderAcceptanceId: e <| Bitflyer.APIKey.childOrderAcceptanceId.keyPath(),
            outstandingSize: e <| Bitflyer.APIKey.outstandingSize.keyPath(),
            cancelSize: e <| Bitflyer.APIKey.cancelSize.keyPath(),
            executedSize: e <| Bitflyer.APIKey.executedSize.keyPath(),
            totalCommission: e <| Bitflyer.APIKey.totalCommission.keyPath())
    }
}
