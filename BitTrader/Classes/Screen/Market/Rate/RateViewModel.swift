//
//  RateViewModel.swift
//  BitTrader
//
//  Created by chako on 2016/10/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

enum RateType: Int {
    case bitflyer
    case btcBox
    case coincheck
    case kraken
    case zaif
    
    func text() -> String {
        switch self {
        case .bitflyer:
            return "Bitflyer"
        case .btcBox:
            return "BtcBox"
        case .coincheck:
            return "Coincheck"
        case .kraken:
            return "Kraken"
        case .zaif:
            return "Zaif"
        }
    }
}

struct RateViewModel {
    
    let rateType: RateType
    let midPrice: Variable<Int>
    let askPrice: Variable<Int>
    let bidPrice: Variable<Int>
}
