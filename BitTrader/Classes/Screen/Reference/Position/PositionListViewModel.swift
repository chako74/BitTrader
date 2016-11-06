//
//  PositionListViewModel.swift
//  BitTrader
//
//  Created by chako on 2016/11/03.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import RxCocoa
import RxSwift

struct PositionListViewModel {
    
    let positionList: Variable<[PositionModel]> = Variable([])
}
