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
    
    let didTap = PublishSubject<PlusMinusInputField>()

    var input = Variable<Double?>(0)
    var upDownUnit = Double(1)
    var min = Double(0)
    var max = DBL_MAX
    var format: String = "%f" {
        didSet {
            if let field = inputFieldLabel {
                guard input.value != nil else {
                    field.text = ""
                    return
                }
                field.text = String(format: format, input.value!)
            }
        }
    }
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var minusButton: UIButton!
    @IBOutlet private weak var inputFieldButton: UIButton!
    @IBOutlet weak var inputFieldLabel: UILabel! {
        didSet {
            inputFieldLabel.font = inputFieldLabel.font.monospacedDigitFont
        }
    }
    
    var inputFieldFontSize: CGFloat = 30.0 {
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
                guard let input = self?.input.value else {
                    self?.input.value = Double(0)
                    return
                }
                self?.input.value = input + (self?.upDownUnit)!
            })
            .addDisposableTo(disposeBag)
        
        minusButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let input = self?.input.value else {
                    self?.input.value = Double(0)
                    return
                }
                self?.input.value = input - (self?.upDownUnit)!
                })
            .addDisposableTo(disposeBag)

        inputFieldButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didTap.on(.next(self!))
                })
            .addDisposableTo(disposeBag)
        
        input
            .asObservable()
            .map { [unowned self] in
                guard $0 != nil else {
                    return ""
                }
                return String(format: self.format, $0!)
            }
            .bindTo(inputFieldLabel.rx.text)
            .addDisposableTo(disposeBag)
    }
}
