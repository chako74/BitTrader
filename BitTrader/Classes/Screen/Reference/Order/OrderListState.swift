//
//  OrderListState.swift
//  BitTrader
//
//  Created by chako on 2016/11/10.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import ReSwift

enum RequestStatus: Int {
    
    case none
    case requesting
    case requested
}

struct OrderListState: StateType {

    let requestStatus: RequestStatus
    let orderList: Array<BitflyerOrderModel>
    let error: Error?
    
    func isNetworkActivityIndicatorVisible() -> Bool {
        switch requestStatus {
        case .none, .requested:
            return false
        case .requesting:
            return true
        }
    }
}
