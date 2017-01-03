//
//  RxBaseSendOrderViewController.swift
//  BitTrader
//
//  Created by chako on 2016/11/26.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class RxBaseSendOrderViewController: UIViewController {

    weak var delegate: RxSendOrderRootViewControllerProtocol?

    func updateBidPrice(price: String) {
        fatalError("updateBidPrice(price:) has not been implemented")
    }
    func updateAskPrice(price: String) {
        fatalError("updateAskPrice(price:) has not been implemented")
    }

    func makeSendOrderChildViewController(condition: Enums.Condition) -> RxBaseSendOrderCommonViewController? {
        switch condition {
        case .limit:
            return RxLimitOrderViewController(bidAsk: .bid)
        case .market:
            return RxMarketOrderViewController(bidAsk: .bid)
        case .stop:
            return RxStopOrderViewController()
        case .stopLimit:
            return RxStopLimitOrderViewController()
        case .trail:
            return RxTrailOrderViewController()
        default:
            return nil
        }
    }

    func makeErrorMessage(_ viewModel: RxSendOrderModel) -> String {
        var message = "\(viewModel.orderType.name)\n"
        message += "\(viewModel.side.rawValue)\n"
        message += "数量:\(viewModel.size)\n"
        message += viewModel.orderType.condition
        return message
    }

    func rootViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow!.rootViewController
    }

    /*
    func convert(_ model: RxSendOrderModel) -> SendOrderModel {
        return SendOrderModel(productCode: viewModel.productType.value,
                              side: convert(model.side),
                              size: model.size,
                              orderType: convert(model.orderType))
    }

    func makeChildOrderParameter(model: RxSendOrderModel) throws -> BitflyerSendChildOrderRequestParameter {
        return BitflyerSendChildOrderRequestParameter(productCode: viewModel.productType.value,
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
 */
}

extension RxBaseSendOrderViewController {
    
    func trigger(selector: Selector) -> Observable<Void> {
        return rx.sentMessage(selector).map { _ in () }.shareReplay(1)
    }
    
    var viewWillAppearTrigger: Observable<Void> {
        return trigger(selector: #selector(self.viewWillAppear(_:)))
    }
    
    var viewDidAppearTrigger: Observable<Void> {
        return trigger(selector: #selector(self.viewDidAppear(_:)))
    }
    
    var viewWillDisappearTrigger: Observable<Void> {
        return trigger(selector: #selector(self.viewWillDisappear(_:)))
    }
    
    var viewDidDisappearTrigger: Observable<Void> {
        return trigger(selector: #selector(self.viewDidDisappear(_:)))
    }
}
