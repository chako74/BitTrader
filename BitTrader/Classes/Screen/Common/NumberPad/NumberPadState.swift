//
//  NumberPadState.swift
//  BitTrader
//
//  Created by chako on 2016/10/15.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation

struct NumberPadState {
    
    static let CLEAR_STATE = NumberPadState(action: .clear, inScreen: "")
    
    let action: NumberPadAction!
    let inScreen: String
}

extension NumberPadState {
    func tranformState(_ x: NumberPadAction) -> NumberPadState {
        switch x {
        case .clear:
            return NumberPadState.CLEAR_STATE
        case .backspace:
            return backspace()
        case .addDot:
            return addDot()
        case .addNumber(let numberStr):
            return addNumber(numberStr)
        }
    }
    
    private func backspace() -> NumberPadState {
        let value = inScreen.isEmpty ?
            inScreen : inScreen.substring(to: inScreen.index(inScreen.endIndex, offsetBy: -1))
        return NumberPadState(action: action, inScreen: value)
    }
    
    private func addNumber(_ number: String) -> NumberPadState {

        var value = inScreen.isEmpty ? number : inScreen + number
        // 先頭で0が続くものは、0に置換
        value = replaceTopContinueZero(value)
        // 整数部で頭0のあとに数値が続いている場合は、頭の0削除
        var spilit = value.components(separatedBy: ".")
        var intPart = spilit[0]
        if 2 <= intPart.characters.count {
            if intPart[intPart.startIndex] == "0" {
                intPart = intPart.substring(from: intPart.index(intPart.startIndex, offsetBy:1))
                spilit[0] = intPart
            }
        }
        return NumberPadState(action: action, inScreen: spilit.joined(separator: "."))
    }
    
    private func addDot() -> NumberPadState {
        var value = containsDot(inScreen) ? inScreen : inScreen + "."
        if value == "." {
            value = "0."
        }
        return NumberPadState(action: action, inScreen: value)
    }
    
    private func containsDot(_ value: String) -> Bool {
        return value.range(of: ".") != nil
    }
    
    private func replaceTopContinueZero(_ value: String) -> String {
        return value.replacingOccurrences(of: "^0+", with: "0", options: .regularExpression, range: nil)
    }
}
