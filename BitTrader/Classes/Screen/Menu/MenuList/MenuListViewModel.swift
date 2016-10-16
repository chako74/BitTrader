//
//  MenuListViewModel.swift
//  BitTrader
//
//  Created by chako on 2016/10/12.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import RxCocoa
import RxSwift

enum MenuType: Int {
    case apiKey
    case btcChanger
    case numberPad
    
    func displayText() -> String {
        
        switch self {
        case .apiKey:
            return "APIキー登録"
        case .btcChanger:
            return "BTC-Satoshi計算"
        case .numberPad:
            return "数値入力"
        }
    }
}

struct MenuListViewModel {
    
    let menus = Variable<[MenuType]>([])
    
    init() {
        menus.value.append(.apiKey)
        menus.value.append(.btcChanger)
        // TODO: 動作確認用
        menus.value.append(.numberPad)
    }
}
