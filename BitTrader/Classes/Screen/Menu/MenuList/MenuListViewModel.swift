//
//  MenuListViewModel.swift
//  BitTrader
//
//  Created by chako on 2016/10/12.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import RxCocoa
import RxSwift

struct MenuListViewModel {
    
    let menus = Variable<[String]>([])
    
    init() {
        menus.value.append("BTC-Satoshi計算")
    }
}
