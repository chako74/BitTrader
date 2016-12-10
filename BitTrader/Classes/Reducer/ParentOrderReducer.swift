//
//  ParentOrderReducer.swift
//  BitTrader
//
//  Created by coaractos on 2016/12/06.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import ReSwift

struct ParentOrderReducer: Reducer {

    func handleAction(action: Action, state: State?) -> State {
        var state = state ?? State()

        switch action {
        case _ as ReSwiftInit:
            break
        case let action as AppAction:
            switch action {
            case .ChildOrderCondition(let place, let condition):
                var cos = SendOrderUtils.selectOrderState(parentOrderState: state.parentOrderState, place: place)
                cos.condition = condition
                state.parentOrderState = makeOrderState(parentOrderState: state.parentOrderState, place: place, hasCondition: cos)

            default:
                return handle(state: state, action: action)
            }

        default:
            break
        }
        return state
    }

    private func handle(state: State, action: AppAction) -> State {
        var state = state
        var orderState = state.parentOrderState

        switch action {
        case .BidAsk(let place, let bidAsk):
            var cos = SendOrderUtils.selectOrderState(parentOrderState: orderState, place: place)
            cos.condition = makeCondition(condition: cos.condition, bidAsk: bidAsk, price: bidAskPrice(bidAsk, rateModel: state.rateModel))
            orderState = makeOrderState(parentOrderState: orderState, place: place, hasCondition: cos)

        case .Amount(let place, let amount):
            var cos = SendOrderUtils.selectOrderState(parentOrderState: orderState, place: place)
            cos.condition = makeCondition(condition: cos.condition, amount: amount)
            orderState = makeOrderState(parentOrderState: orderState, place: place, hasCondition: cos)

        case .Price(let place, let price):
            var cos = SendOrderUtils.selectOrderState(parentOrderState: orderState, place: place)
            cos.condition = makeCondition(condition: cos.condition, price: price)
            orderState = makeOrderState(parentOrderState: orderState, place: place, hasCondition: cos)

        case .TriggerPrice(let place, let triggerPrice):
            var cos = SendOrderUtils.selectOrderState(parentOrderState: orderState, place: place)
            cos.condition = makeCondition(condition: cos.condition, triggerPrice: triggerPrice)
            orderState = makeOrderState(parentOrderState: orderState, place: place, hasCondition: cos)

        case .Offset(let place, let offset):
            var cos = SendOrderUtils.selectOrderState(parentOrderState: orderState, place: place)
            cos.condition = makeCondition(condition: cos.condition, offset: offset)
            orderState = makeOrderState(parentOrderState: orderState, place: place, hasCondition: cos)

        default:
            break
        }

        state.parentOrderState = orderState
        return state
    }

    private func bidAskPrice(_ bidAsk: Enums.BidAsk, rateModel: RateModel?) -> Double? {
        guard let rateModel = rateModel else {
            return nil
        }
        let price: Int
        switch bidAsk {
        case .bid:
            price = rateModel.bidPrice
        case .ask:
            price = rateModel.askPrice
        }
        return Double(price)
    }

    private func makeCondition(condition: ChildOrderCondition, bidAsk: Enums.BidAsk, price: Double?) -> ChildOrderCondition {
        switch condition {
        case .limit(_, let amount, _):
            return .limit(bidAsk: bidAsk, amount: amount, price: price)
        case .market(_, let amount):
            return .market(bidAsk: bidAsk, amount: amount)
        case .stop(_, let amount, let triggerPrice):
            return .stop(bidAsk: bidAsk, amount: amount, triggerPrice: triggerPrice)
        case .stopLimit(_, let amount, _, let triggerPrice):
            return .stopLimit(bidAsk: bidAsk, amount: amount, price: price, triggerPrice: triggerPrice)
        case .trail(_, let amount, let offset):
            return .trail(bidAsk: bidAsk, amount: amount, offset: offset)
        }
    }

    private func makeCondition(condition: ChildOrderCondition, amount: String?) -> ChildOrderCondition {
        switch condition {
        case .limit(let bidAsk, _, let price):
            return .limit(bidAsk: bidAsk, amount: amount, price: price)
        case .market(let bidAsk, _):
            return .market(bidAsk: bidAsk, amount: amount)
        case .stop(let bidAsk, _, let triggerPrice):
            return .stop(bidAsk: bidAsk, amount: amount, triggerPrice: triggerPrice)
        case .stopLimit(let bidAsk, _, let price, let triggerPrice):
            return .stopLimit(bidAsk: bidAsk, amount: amount, price: price, triggerPrice: triggerPrice)
        case .trail(let bidAsk, _, let offset):
            return .trail(bidAsk: bidAsk, amount: amount, offset: offset)
        }
    }

    private func makeCondition(condition: ChildOrderCondition, price: Double?) -> ChildOrderCondition {
        switch condition {
        case .limit(let bidAsk, let amount, _):
            return .limit(bidAsk: bidAsk, amount: amount, price: price)
        case .stopLimit(let bidAsk, let amount, _, let triggerPrice):
            return .stopLimit(bidAsk: bidAsk, amount: amount, price: price, triggerPrice: triggerPrice)
        default:
            return condition
        }
    }

    private func makeCondition(condition: ChildOrderCondition, triggerPrice: Double?) -> ChildOrderCondition {
        switch condition {
        case .stop(let bidAsk, let amount, _):
            return .stop(bidAsk: bidAsk, amount: amount, triggerPrice: triggerPrice)
        case .stopLimit(let bidAsk, let amount, let price, _):
            return .stopLimit(bidAsk: bidAsk, amount: amount, price: price, triggerPrice: triggerPrice)
        default:
            return condition
        }
    }

    private func makeCondition(condition: ChildOrderCondition, offset: Double?) -> ChildOrderCondition {
        switch condition {
        case .trail(let bidAsk, let amount, _):
            return .trail(bidAsk: bidAsk, amount: amount, offset: offset)
        default:
            return condition
        }
    }

    private func makeOrderState(parentOrderState: ParentOrderState, place: Enums.Place, hasCondition: HasCondition) -> ParentOrderState {
        switch place {
        case .First:
            switch parentOrderState {
            case .simple:
                return .simple(hasCondition)
            case .ifd(_, let state):
                return .ifd(if: hasCondition, done: state)
            case .oco(_, let state):
                return .oco(oco1: hasCondition, oco2: state)
            case .ifdoco(_, let state1, let state2):
                return .ifdoco(if: hasCondition, oco1: state1, oco2: state2)
            }
        case .Second:
            switch parentOrderState {
            case .ifd(let state, _):
                return .ifd(if: state, done: hasCondition)
            case .oco(let state, _):
                return .oco(oco1: state, oco2: hasCondition)
            case .ifdoco(let state1, _, let state2):
                return .ifdoco(if: state1, oco1: hasCondition, oco2: state2)
            default:
                fatalError("invalid argument.")
            }
        case .Third:
            switch parentOrderState {
            case .ifdoco(let state1, let state2, _):
                return .ifdoco(if: state1, oco1: state2, oco2: hasCondition)
            default:
                fatalError("invalid argument.")
            }
        }
    }
    
}
