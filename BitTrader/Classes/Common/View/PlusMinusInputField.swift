//
//  PlusMinusInputField.swift
//  BitTrader
//
//  Created by chako on 2016/10/12.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

class PlusMinusInputField: UIView {
    
    var upDownUnit = Double(1)
    var min = Double(0)
    var max = Double(99999999)
    
    private let disposeBag = DisposeBag()
    private var input = Variable(Double(0))
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var minusButton: UIButton!
    @IBOutlet private weak var inputFieldLabel: UILabel!
    
    var inputFieldFontSize: CGFloat = 35.0 {
        didSet {
            inputFieldLabel?.font = inputFieldLabel.font.withSize(inputFieldFontSize)
        }
    }
        
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadXib()
        bind()
    }
    
    private func loadXib() {
        Bundle.main.loadNibNamed("PlusMinusInputField", owner: self, options: nil)
        contentView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        addSubview(contentView)
    }
    
    private func bind() {
        plusButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let input = self?.input.value, let unit = self?.upDownUnit {
                    self?.update(input: input + unit)
                    }
                })
            .addDisposableTo(disposeBag)
        
        minusButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let input = self?.input.value, let unit = self?.upDownUnit {
                    self?.update(input: input - unit)
                }
                })
            .addDisposableTo(disposeBag)
        
        input
            .asObservable()
            .map { String(describing: $0) }
            .bindTo(inputFieldLabel.rx.text)
            .addDisposableTo(disposeBag)
    }
    
    private func update(input: Double) {
        
        if min <= input && input <= max {
            self.input.value = input
        }
    }
}
