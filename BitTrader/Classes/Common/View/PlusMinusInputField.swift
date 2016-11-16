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

protocol PlusMinusInputFieldDelegate: NSObjectProtocol {
    
    func didTapedPlusMinusInputField(_ field: PlusMinusInputField)
    func plusMinusInputField(_ plusMinusInputField: PlusMinusInputField, changedValue: Double?)
}

class PlusMinusInputField: UIView {
    
    weak var delegate: PlusMinusInputFieldDelegate?
    
    var input = Variable<Double?>(0)
    var upDownUnit = Double(1)
    var min = Double(0)
    var max = DBL_MAX
    var format: String = "%f" {
        didSet {
            if let field = inputFieldLabel {
                if let value = input.value {
                    field.text = String(format: format, value)
                } else {
                    field.text = ""
                }
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
                guard let sSelf = self else {
                    return
                }
                if let input = sSelf.input.value {
                    sSelf.input.value = input + sSelf.upDownUnit
                } else {
                    sSelf.input.value = Double(0)
                }
                sSelf.delegate?.plusMinusInputField(sSelf, changedValue: sSelf.input.value)
            })
            .addDisposableTo(disposeBag)
        
        minusButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let sSelf = self else {
                    return
                }
                if let input = sSelf.input.value {
                    sSelf.input.value = input - sSelf.upDownUnit
                } else {
                    sSelf.input.value = Double(0)
                }
                sSelf.delegate?.plusMinusInputField(sSelf, changedValue: sSelf.input.value)
            })
            .addDisposableTo(disposeBag)

        inputFieldButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let sSelf = self else {
                    return
                }
                sSelf.delegate?.didTapedPlusMinusInputField(sSelf)
            })
            .addDisposableTo(disposeBag)
        
        input
            .asDriver()
            .map { [weak self] in
                guard let sSelf = self else {
                    return ""
                }
                if let value = $0 {
                    return String(format: sSelf.format, value)
                } else {
                    return ""
                }
            }
            .drive(inputFieldLabel.rx.text)
            .addDisposableTo(disposeBag)
    }
}
