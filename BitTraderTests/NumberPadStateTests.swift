//
//  NumberPadStateTests.swift
//  BitTrader
//
//  Created by chako on 2016/10/15.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import XCTest

@testable import BitTrader

class NumberPadStateTests: XCTestCase {
    
    func test初期値入力() {
        let initialState = NumberPadState.CLEAR_STATE
        // 初期値確認
        XCTAssertEqual(initialState.inScreen, "", "initial state failure")
        // addDot
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addDot).inScreen, "0.", "addDot failure")
        // backspace
        XCTAssertEqual(initialState.tranformState(NumberPadAction.backspace).inScreen, "", "backspace failure")
        // clear
        XCTAssertEqual(initialState.tranformState(NumberPadAction.clear).inScreen, "", "clear failure")
        // number 0
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("0")).inScreen, "0", "number input 0 failure")
        // number 1
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("1")).inScreen, "1", "number input 1 failure")
        // number 2
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("2")).inScreen, "2", "number input 2 failure")
        // number 3
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("3")).inScreen, "3", "number input 3 failure")
        // number 4
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("4")).inScreen, "4", "number input 4 failure")
        // number 5
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("5")).inScreen, "5", "number input 5 failure")
        // number 6
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("6")).inScreen, "6", "number input 6 failure")
        // number 7
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("7")).inScreen, "7", "number input 7 failure")
        // number 8
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("8")).inScreen, "8", "number input 8 failure")
        // number 9
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("9")).inScreen, "9", "number input 9 failure")
        // number 000
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("000")).inScreen, "0", "number input 000 failure")
    }
    
    func test初期値0から入力() {
        
        var initialState = NumberPadState.CLEAR_STATE
        initialState = initialState.tranformState(NumberPadAction.addNumber("0"))
        
        // 初期値確認
        XCTAssertEqual(initialState.inScreen, "0", "initial state failure")
        // addDot
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addDot).inScreen, "0.", "addDot failure")
        // backspace
        XCTAssertEqual(initialState.tranformState(NumberPadAction.backspace).inScreen, "", "backspace failure")
        // clear
        XCTAssertEqual(initialState.tranformState(NumberPadAction.clear).inScreen, "", "clear failure")
        // number 0
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("0")).inScreen, "0", "number input 0 failure")
        // number 1
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("1")).inScreen, "1", "number input 1 failure")
        // number 2
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("2")).inScreen, "2", "number input 2 failure")
        // number 3
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("3")).inScreen, "3", "number input 3 failure")
        // number 4
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("4")).inScreen, "4", "number input 4 failure")
        // number 5
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("5")).inScreen, "5", "number input 5 failure")
        // number 6
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("6")).inScreen, "6", "number input 6 failure")
        // number 7
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("7")).inScreen, "7", "number input 7 failure")
        // number 8
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("8")).inScreen, "8", "number input 8 failure")
        // number 9
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("9")).inScreen, "9", "number input 9 failure")
        // number 000
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("000")).inScreen, "0", "number input 000 failure")
    }
    
    func test初期値数値から入力() {
        
        var initialState = NumberPadState.CLEAR_STATE
        initialState = initialState.tranformState(NumberPadAction.addNumber("1"))
        
        // 初期値確認
        XCTAssertEqual(initialState.inScreen, "1", "initial state failure")
        // addDot
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addDot).inScreen, "1.", "addDot failure")
        // backspace
        XCTAssertEqual(initialState.tranformState(NumberPadAction.backspace).inScreen, "", "backspace failure")
        // clear
        XCTAssertEqual(initialState.tranformState(NumberPadAction.clear).inScreen, "", "clear failure")
        // number 0
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("0")).inScreen, "10", "number input 0 failure")
        // number 1
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("1")).inScreen, "11", "number input 1 failure")
        // number 2
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("2")).inScreen, "12", "number input 2 failure")
        // number 3
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("3")).inScreen, "13", "number input 3 failure")
        // number 4
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("4")).inScreen, "14", "number input 4 failure")
        // number 5
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("5")).inScreen, "15", "number input 5 failure")
        // number 6
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("6")).inScreen, "16", "number input 6 failure")
        // number 7
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("7")).inScreen, "17", "number input 7 failure")
        // number 8
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("8")).inScreen, "18", "number input 8 failure")
        // number 9
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("9")).inScreen, "19", "number input 9 failure")
        // number 000
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("000")).inScreen, "1000", "number input 000 failure")
    }
    
    func test初期値整数部複数桁から入力() {
        
        var initialState = NumberPadState.CLEAR_STATE
        initialState = initialState.tranformState(NumberPadAction.addNumber("1"))
        initialState = initialState.tranformState(NumberPadAction.addNumber("2"))
        
        // 初期値確認
        XCTAssertEqual(initialState.inScreen, "12", "initial state failure")
        // addDot
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addDot).inScreen, "12.", "addDot failure")
        // backspace
        XCTAssertEqual(initialState.tranformState(NumberPadAction.backspace).inScreen, "1", "backspace failure")
        // clear
        XCTAssertEqual(initialState.tranformState(NumberPadAction.clear).inScreen, "", "clear failure")
        // number 0
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("0")).inScreen, "120", "number input 0 failure")
        // number 1
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("1")).inScreen, "121", "number input 1 failure")
        // number 2
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("2")).inScreen, "122", "number input 2 failure")
        // number 3
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("3")).inScreen, "123", "number input 3 failure")
        // number 4
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("4")).inScreen, "124", "number input 4 failure")
        // number 5
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("5")).inScreen, "125", "number input 5 failure")
        // number 6
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("6")).inScreen, "126", "number input 6 failure")
        // number 7
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("7")).inScreen, "127", "number input 7 failure")
        // number 8
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("8")).inScreen, "128", "number input 8 failure")
        // number 9
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("9")).inScreen, "129", "number input 9 failure")
        // number 000
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("000")).inScreen, "12000", "number input 000 failure")
    }
    
    func test初期値小数点ありから入力() {
        
        var initialState = NumberPadState.CLEAR_STATE
        initialState = initialState.tranformState(NumberPadAction.addDot)
        
        // 初期値確認
        XCTAssertEqual(initialState.inScreen, "0.", "initial state failure")
        // addDot
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addDot).inScreen, "0.", "addDot failure")
        // backspace
        XCTAssertEqual(initialState.tranformState(NumberPadAction.backspace).inScreen, "0", "backspace failure")
        // clear
        XCTAssertEqual(initialState.tranformState(NumberPadAction.clear).inScreen, "", "clear failure")
        // number 0
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("0")).inScreen, "0.0", "number input 0 failure")
        // number 1
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("1")).inScreen, "0.1", "number input 1 failure")
        // number 2
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("2")).inScreen, "0.2", "number input 2 failure")
        // number 3
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("3")).inScreen, "0.3", "number input 3 failure")
        // number 4
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("4")).inScreen, "0.4", "number input 4 failure")
        // number 5
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("5")).inScreen, "0.5", "number input 5 failure")
        // number 6
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("6")).inScreen, "0.6", "number input 6 failure")
        // number 7
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("7")).inScreen, "0.7", "number input 7 failure")
        // number 8
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("8")).inScreen, "0.8", "number input 8 failure")
        // number 9
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("9")).inScreen, "0.9", "number input 9 failure")
        // number 000
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("000")).inScreen, "0.000", "number input 000 failure")
    }
    
    func test初期値小数点ありの小数部複数桁から入力() {
        
        var initialState = NumberPadState.CLEAR_STATE
        initialState = initialState.tranformState(NumberPadAction.addDot)
        initialState = initialState.tranformState(NumberPadAction.addNumber("3"))
        
        // 初期値確認
        XCTAssertEqual(initialState.inScreen, "0.3", "initial state failure")
        // addDot
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addDot).inScreen, "0.3", "addDot failure")
        // backspace
        XCTAssertEqual(initialState.tranformState(NumberPadAction.backspace).inScreen, "0.", "backspace failure")
        // clear
        XCTAssertEqual(initialState.tranformState(NumberPadAction.clear).inScreen, "", "clear failure")
        // number 0
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("0")).inScreen, "0.30", "number input 0 failure")
        // number 1
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("1")).inScreen, "0.31", "number input 1 failure")
        // number 2
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("2")).inScreen, "0.32", "number input 2 failure")
        // number 3
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("3")).inScreen, "0.33", "number input 3 failure")
        // number 4
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("4")).inScreen, "0.34", "number input 4 failure")
        // number 5
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("5")).inScreen, "0.35", "number input 5 failure")
        // number 6
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("6")).inScreen, "0.36", "number input 6 failure")
        // number 7
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("7")).inScreen, "0.37", "number input 7 failure")
        // number 8
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("8")).inScreen, "0.38", "number input 8 failure")
        // number 9
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("9")).inScreen, "0.39", "number input 9 failure")
        // number 000
        XCTAssertEqual(initialState.tranformState(NumberPadAction.addNumber("000")).inScreen, "0.3000", "number input 000 failure")
    }
}

