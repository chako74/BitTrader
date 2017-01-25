//
//  ReReBaseSendOrderViewController.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/26.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

class ReBaseSendOrderViewController: UIViewController {

    var productType: Bitflyer.ProductCodeType

    init(productType: Bitflyer.ProductCodeType) {
        self.productType = productType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func remakeSendOrderChildViewController(place: OldEnums.Place, condition: OldEnums.Condition) -> ReBaseSendOrderCommonViewController? {
        switch condition {
        case .limit:
            return ReLimitOrderViewController(place: place)
        case .market:
            return ReMarketOrderViewController(place: place)
        case .stop:
            return ReStopOrderViewController(place: place)
        case .stopLimit:
            return ReStopLimitOrderViewController(place: place)
        case .trail:
            return ReTrailOrderViewController(place: place)
        default:
            return nil
        }
    }

    func makeErrorMessage(_ viewModel: ReSendOrderViewModel) -> String {
        var message = "\(viewModel.orderType.name)\n"
        message += "\(viewModel.side.rawValue)\n"
        message += "数量:\(viewModel.size)\n"
        message += viewModel.orderType.condition
        return message
    }

    func convert(_ model: ReSendOrderViewModel) -> SendOrderModel {
        return SendOrderModel(productCode: productType,
                              side: convert(model.side),
                              size: model.size,
                              orderType: convert(model.orderType))
    }

    func makeChildOrderParameter(model: ReSendOrderViewModel) throws -> BitflyerSendChildOrderRequestParameter {
        return BitflyerSendChildOrderRequestParameter(productCode: productType,
                                                      orderType: try convert(model.orderType),
                                                      side: convert(model.side),
                                                      size: model.size,
                                                      minuteToExpire: nil,
                                                      timeInForce: nil)
    }

    func makeParentOrderParameter(orderMethodType: Bitflyer.OrderMethodType, parameters: [SendOrderModel]) -> BitflyerSendParentOrderParameter {
        return BitflyerSendParentOrderParameter(orderMethod: orderMethodType,
                                                minuteToExpire: nil,
                                                timeInForce: nil,
                                                parameters: parameters)
    }

    func rootViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow!.rootViewController
    }

    private func convert(_ bidAsk: OldEnums.BidAsk) -> Bitflyer.SideType {
        let type: Bitflyer.SideType
        switch bidAsk {
        case .bid:
            type = .sell
        case .ask:
            type = .buy
        }
        return type
    }

    private func convert(_ orderType: OldEnums.OrderType) -> Bitflyer.SpecialOrderType {
        let type: Bitflyer.SpecialOrderType
        switch orderType {
        case .market:
            type = .market
        case .limit(let price):
            type = .limit(price: price)
        case .stop(let triggerPrice):
            type = .stop(triggerPrice: triggerPrice)
        case .stopLimit(let price, let triggerPrice):
            type = .stopLimit(price: price, triggerPrice: triggerPrice)
        case .trail(let trailDistance):
            type = .trail(trailDistance: trailDistance)
        }
        return type
    }

    private func convert(_ orderType: OldEnums.OrderType) throws -> Bitflyer.NomalOrderType {
        let type: Bitflyer.NomalOrderType
        switch orderType {
        case .market:
            type = .market
        case .limit(let price):
            type = .limit(price: price)
        default:
            throw BitTraderError.SyntaxError(message: "cannot convert OrderType to NomalOrderType")
        }
        return type
    }
}
