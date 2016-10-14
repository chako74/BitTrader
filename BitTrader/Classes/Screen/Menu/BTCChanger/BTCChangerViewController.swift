//
//  BTCChangerViewController.swift
//  BitTrader
//
//  Created by chako on 2016/10/12.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class BTCChangerViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private var btcAmount = Variable(Double(0))
    
    @IBOutlet private weak var btcPlusMinusInput: PlusMinusInputField?
    @IBOutlet private weak var satoshiPlusMinusInput: PlusMinusInputField?
    @IBOutlet private weak var clearButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btcPlusMinusInput!.format = "%.8f"
        satoshiPlusMinusInput!.format = "%.0f"
        
        btcPlusMinusInput!.input
            .asObservable()
            .map() { input -> Double in
                return input / 0.00000001
            }
            .subscribe(onNext: { [weak self] input in
                self?.satoshiPlusMinusInput?.update(input: input)
            })
            .addDisposableTo(disposeBag)
        
        satoshiPlusMinusInput!.input
            .asObservable()
            .map() { input -> Double in
                return input * 0.00000001
            }
            .subscribe(onNext: { [weak self] input in
                self?.btcPlusMinusInput?.update(input: input)
            })
            .addDisposableTo(disposeBag)
        
        clearButton!.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.btcPlusMinusInput!.update(input: 0)
                self?.satoshiPlusMinusInput!.update(input: 0)
            })
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
