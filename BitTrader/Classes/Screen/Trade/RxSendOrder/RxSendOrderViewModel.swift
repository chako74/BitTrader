//
//  RxSendOrderViewModel.swift
//  BitTrader
//
//  Created by chako on 2016/11/28.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import RxCocoa
import RxSwift

class RxSendOrderViewModel {
    
    let productType: Variable<Bitflyer.ProductCodeType>
    private(set) var selectedOrder: Variable<Enums.Order>
    
    init(productType: Bitflyer.ProductCodeType, order: Enums.Order) {
        
        self.productType = Variable(productType)
        self.selectedOrder = Variable(order)
    }
    
    func setSelectedBidAsk(_ bidAsk: Enums.BidAsk) {
        RxSendOrderGlobalModel.sharedInstance.selectedBidAsk.value = bidAsk
    }
    
    func selectedBidAsk() -> Variable<Enums.BidAsk?> {
        return RxSendOrderGlobalModel.sharedInstance.selectedBidAsk
    }
    
    func bidRate() -> Variable<Int?> {
        return RxSendOrderGlobalModel.sharedInstance.bidRate
    }
    
    func askRate() -> Variable<Int?> {
        return RxSendOrderGlobalModel.sharedInstance.askRate
    }
    
    func subscribe() {
        RxSendOrderGlobalModel.sharedInstance.subscribe(productCodeType: productType.value)
    }
    
    func unsubscribe() {
        RxSendOrderGlobalModel.sharedInstance.unsubscribe()
    }
    
    func tradeTypeComponentCount() -> Int {
        return 1
    }
    
    func tradeTypeCount(numberOfRowsInComponent component: Int) -> Int {
        return Enums.Order.count
    }
    
    func tradeTypeTitleForRow(_ row: Int, forComponent component: Int) -> String? {
        return Enums.Order(rawValue: row)?.name
    }
    
    func updateDidSelectedPicker(row: Int, inComponent component: Int) {
        // 注文方法の更新
        if let order = Enums.Order(rawValue: row) {
            selectedOrder.value = order
        }
    }
}
