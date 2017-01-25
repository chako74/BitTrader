//
//  RxMarketOrderViewModel.swift
//  BitTrader
//
//  Created by chako on 2016/12/14.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import RxCocoa
import RxSwift

class RxMarketOrderViewModel {
    
    func setSelectedBidAsk(_ selectedBidAsk: OldEnums.BidAsk?) {
        RxSendOrderGlobalModel.sharedInstance.selectedBidAsk.value = selectedBidAsk
    }
    
    func selectedBidAsk() -> Variable<OldEnums.BidAsk?> {
        return RxSendOrderGlobalModel.sharedInstance.selectedBidAsk
    }
    
    func setOpenAmount(_ openAmount: Double?) {
        RxSendOrderGlobalModel.sharedInstance.openAmount.value = openAmount
    }
    
    func openAmount() -> Variable<Double?> {
        return RxSendOrderGlobalModel.sharedInstance.openAmount
    }
    
    func executeOrder() throws {
        
    }
}
