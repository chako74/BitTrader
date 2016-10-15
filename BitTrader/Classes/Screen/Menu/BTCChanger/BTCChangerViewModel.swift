//
//  BTCChangerViewModel.swift
//  BitTrader
//
//  Created by chako on 2016/10/15.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import RxCocoa
import RxSwift

struct BTCChangerViewModel {
    let btcAmount = Variable(Double(0))
    let midPrice = Variable(Int(0))
}
