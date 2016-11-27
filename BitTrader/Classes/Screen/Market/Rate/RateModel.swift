//
//  RateModel.swift
//  BitTrader
//
//  Created by chako on 2016/10/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation

enum RateType: Int {
    case bitflyer
    case bitflyerFx
    case btcBox
    case coincheck
    case kraken
    case zaif
    
    func text() -> String {
        switch self {
        case .bitflyer:
            return "Bitflyer"
        case .bitflyerFx:
            return "Bitflyer FX"
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

struct RateModel {
    
    let rateType: RateType
    let midPrice: Int
    let askPrice: Int
    let bidPrice: Int
}
