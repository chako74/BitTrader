//
//  ReReBaseSendOrderViewController.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/26.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

class ReBaseSendOrderViewController: UIViewController {

    weak var delegate: ReSendOrderRootViewControllerProtocol?
    var condition: Enums.Condition
    var productType: Bitflyer.ProductCodeType

    init(productType: Bitflyer.ProductCodeType, condition: Enums.Condition, delegete: ReSendOrderRootViewControllerProtocol) {
        self.condition = condition
        self.delegate = delegete
        self.productType = productType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateCondition(_ condition: Enums.Condition) {
        fatalError("updateCondition(:) has not been implemented")
    }
    func updateBidRate(rate: String) {
        fatalError("updateBidRate(rate:) has not been implemented")
    }
    func updateAskRate(rate: String) {
        fatalError("updateAskRate(rate:) has not been implemented")
    }

    func RemackSendOrderChildViewController(condition: Enums.Condition) -> ReBaseSendOrderCommonViewController? {
        switch condition {
        case .limit:
            return ReLimitOrderViewController(bidAsk: .bid, delegete: delegate!)
        case .market:
            return ReMarketOrderViewController()
        case .stop:
            return ReStopOrderViewController()
        case .stopLimit:
            return ReStopLimitOrderViewController()
        case .trail:
            return ReTrailOrderViewController()
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

    private func convert(_ bidAsk: Enums.BidAsk) -> Bitflyer.SideType {
        let type: Bitflyer.SideType
        switch bidAsk {
        case .bid:
            type = .sell
        case .ask:
            type = .buy
        }
        return type
    }

    private func convert(_ orderType: Enums.OrderType) -> Bitflyer.SpecialOrderType {
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

    private func convert(_ orderType: Enums.OrderType) throws -> Bitflyer.NomalOrderType {
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
