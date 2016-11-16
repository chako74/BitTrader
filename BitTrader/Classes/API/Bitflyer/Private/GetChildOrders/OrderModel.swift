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
    let productCode: ProductCodeType
    let side: SideType
    let childOrderType: ChildOrderType
    let price: Int
    let averagePrice: Int
    let size: Double
    let childOrderState: ChildOrderState
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
            id: e <| APIKey.id.keyPath(),
            childOrderId: e <| APIKey.childOrderId.keyPath(),
            productCode: ProductCodeType(rawValue: e <| APIKey.productCode.keyPath())!,
            side: SideType(rawValue: e <| APIKey.side.keyPath())!,
            childOrderType: ChildOrderType(rawValue: e <| APIKey.childOrderType.keyPath())!,
            price: e <| APIKey.price.keyPath(),
            averagePrice: e <| APIKey.averagePrice.keyPath(),
            size: e <| APIKey.size.keyPath(),
            childOrderState: ChildOrderState(rawValue: e <| APIKey.childOrderState.keyPath())!,
            expireDate: e <| APIKey.expireDate.keyPath(),
            childOrderDate: e <| APIKey.childOrderDate.keyPath(),
            childOrderAcceptanceId: e <| APIKey.childOrderAcceptanceId.keyPath(),
            outstandingSize: e <| APIKey.outstandingSize.keyPath(),
            cancelSize: e <| APIKey.cancelSize.keyPath(),
            executedSize: e <| APIKey.executedSize.keyPath(),
            totalCommission: e <| APIKey.totalCommission.keyPath())
    }
}
