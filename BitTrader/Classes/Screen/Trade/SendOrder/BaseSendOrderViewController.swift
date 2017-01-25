//
//  BaseSendOrderViewController.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/26.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

class BaseSendOrderViewController: UIViewController {

    weak var delegate: SendOrderRootViewControllerProtocol?
    var productType: Bitflyer.ProductCodeType

    init(productType: Bitflyer.ProductCodeType, delegete: SendOrderRootViewControllerProtocol) {
        self.productType = productType
        self.delegate = delegete
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateBidPrice(price: String) {
        fatalError("updateBidPrice(price:) has not been implemented")
    }
    
    func updateAskPrice(price: String) {
        fatalError("updateAskPrice(price:) has not been implemented")
    }

    func makeSendOrderChildViewController(condition: OldEnums.Condition) -> BaseSendOrderCommonViewController? {
        switch condition {
        case .limit:
            return LimitOrderViewController(bidAsk: .bid, delegete: delegate!)
        case .market:
            return MarketOrderViewController(bidAsk: .bid, delegete: delegate!)
        case .stop:
            return StopOrderViewController(bidAsk: .bid, delegete: delegate!)
        case .stopLimit:
            return StopLimitOrderViewController(bidAsk: .bid, delegete: delegate!)
        case .trail:
            return TrailOrderViewController(bidAsk: .bid, delegete: delegate!)
        default:
            return nil
        }
    }

    func makeErrorMessage(_ viewModel: SendOrderViewModel) -> String {
        var message = "\(viewModel.orderType.name)\n"
        message += "\(viewModel.side.rawValue)\n"
        message += "数量:\(viewModel.size)\n"
        message += viewModel.orderType.condition
        return message
    }

    func convert(_ model: SendOrderViewModel) -> SendOrderModel {
        return SendOrderModel(productCode: productType,
                              side: convert(model.side),
                              size: model.size,
                              orderType: convert(model.orderType))
    }

    func makeChildOrderParameter(model: SendOrderViewModel) throws -> BitflyerSendChildOrderRequestParameter {
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
