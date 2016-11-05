//
//  NumberPadViewController.swift
//  BitTrader
//
//  Created by chako on 2016/10/15.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class NumberPadViewController: UIViewController {

    let rx_tap_done = PublishSubject<String>()

    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var resultLabel: UILabel!
    
    @IBOutlet private weak var clearButton: UIButton!
    @IBOutlet private weak var backspaceButton: UIButton!

    @IBOutlet private weak var dotButton: UIButton!
    
    @IBOutlet private weak var zeroButton: UIButton!
    @IBOutlet private weak var oneButton: UIButton!
    @IBOutlet private weak var twoButton: UIButton!
    @IBOutlet private weak var threeButton: UIButton!
    @IBOutlet private weak var fourButton: UIButton!
    @IBOutlet private weak var fiveButton: UIButton!
    @IBOutlet private weak var sixButton: UIButton!
    @IBOutlet private weak var sevenButton: UIButton!
    @IBOutlet private weak var eightButton: UIButton!
    @IBOutlet private weak var nineButton: UIButton!
    
    @IBOutlet private weak var thousandButton: UIButton!
    
    @IBOutlet private weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func bind() {
        let commands: [Observable<NumberPadAction>] =
        [
            clearButton.rx.tap.map { _ in .clear },
            backspaceButton.rx.tap.map { _ in .backspace },
            
            dotButton.rx.tap.map { _ in .addDot },
            
            zeroButton.rx.tap.map { _ in .addNumber("0") },
            oneButton.rx.tap.map { _ in .addNumber("1") },
            twoButton.rx.tap.map { _ in .addNumber("2") },
            threeButton.rx.tap.map { _ in .addNumber("3") },
            fourButton.rx.tap.map { _ in .addNumber("4") },
            fiveButton.rx.tap.map { _ in .addNumber("5") },
            sixButton.rx.tap.map { _ in .addNumber("6") },
            sevenButton.rx.tap.map { _ in .addNumber("7") },
            eightButton.rx.tap.map { _ in .addNumber("8") },
            nineButton.rx.tap.map { _ in .addNumber("9") },
            
            thousandButton.rx.tap.map { _ in .addNumber("000") },

            doneButton.rx.tap.map { _ in .done },

        ]
        
        Observable.from(commands)
            .merge()
            .scan(NumberPadState.CLEAR_STATE) { state, action in
                switch state.action {
                case NumberPadAction.done:
                    return NumberPadState.CLEAR_STATE.tranformState(action)
                default:
                    return state.tranformState(action)
                }
            }
            .subscribe(onNext: { [weak self] state in
                switch state.action {
                case NumberPadAction.done:
                    self?.rx_tap_done.on(.next(state.inScreen))
                    self?.resultLabel.text = ""
                default:
                    self?.resultLabel.text = state.inScreen
                }
            })
        .addDisposableTo(disposeBag)
    }
}
