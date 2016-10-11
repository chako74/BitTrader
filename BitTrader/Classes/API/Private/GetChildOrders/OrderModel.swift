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
    let productCode: String
    let side: String
    let childOrderType: String
    let price: Int
    let averagePrice: Int
    let size: Double
    let childOrderState: String
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
            id: e <| "id",
            childOrderId: e <| "child_order_id",
            productCode: e <| "product_code",
            side: e <| "side",
            childOrderType: e <| "child_order_type",
            price: e <| "price",
            averagePrice: e <| "average_price",
            size: e <| "size",
            childOrderState: e <| "child_order_state",
            expireDate: e <| "expire_date",
            childOrderDate: e <| "child_order_date",
            childOrderAcceptanceId: e <| "child_order_acceptance_id",
            outstandingSize: e <| "outstanding_size",
            cancelSize: e <| "cancel_size",
            executedSize: e <| "executed_size",
            totalCommission: e <| "total_commission")
    }
}
