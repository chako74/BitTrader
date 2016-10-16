//
//  IndentLabel.swift
//  BitTrader
//
//  Created by chako on 2016/10/15.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class IndentLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}
