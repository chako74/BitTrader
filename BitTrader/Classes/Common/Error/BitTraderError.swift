//
//  BitTraderError.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/26.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation

enum BitTraderError: Error {
    case SyntaxError(message: String)
    case ValidationError(message: String)

    var message: String {
        switch self {
        case .SyntaxError(let message) : return message
        case .ValidationError(let message): return message
        }
    }
}
