//
//  RateListViewModel.swift
//  BitTrader
//
//  Created by chako on 2016/10/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

struct RateListViewModel {
    
    let rateList: Variable<[RateViewModel]> = Variable([])
}
