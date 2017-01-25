//
//  RxSimpleOrderViewModel.swift
//  BitTrader
//
//  Created by chako on 2016/12/19.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import RxCocoa
import RxSwift

class RxSimpleOrderViewModel {
    
    private(set) var selectedCondition: Variable<OldEnums.Condition>
    
    init(condition: OldEnums.Condition) {
        self.selectedCondition = Variable(condition)
    }
    
    func tradeTypeComponentCount() -> Int {
        return 1
    }
    
    func tradeTypeCount(numberOfRowsInComponent component: Int) -> Int {
        return OldEnums.Condition.count
    }
    
    func tradeTypeTitleForRow(_ row: Int, forComponent component: Int) -> String? {
        return OldEnums.Condition(rawValue: row)?.name
    }
    
    func updateDidSelectedPicker(row: Int, inComponent component: Int) {
        // 注文の執行条件の更新
        if let condition = OldEnums.Condition(rawValue: row) {
            selectedCondition.value = condition
        }
    }
}
