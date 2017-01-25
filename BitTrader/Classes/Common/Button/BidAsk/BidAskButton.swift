//
//  BidAskButton.swift
//  BitTrader
//
//  Created by coaractos on 2016/12/12.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import UIKit

class BidAskButton: UIButton {

    private var bidAsk: OldEnums.BidAsk?

    func initializeBidAsk(_ bidAsk: OldEnums.BidAsk) {
        self.bidAsk = bidAsk
        background()

        self.setTitleColor(.white, for: .normal)
        self.font(UIFont(name: "HelveticaNeue-Bold", size: 13.0)!)
    }

    func title(_ title: String?) {
        self.setTitle(title, for: .normal)
    }

    func font(_ font: UIFont) {
        self.titleLabel?.font = font
    }

    func selected(bidAsk: OldEnums.BidAsk?) {
        if self.bidAsk == bidAsk {
            self.isSelected = true
        } else {
            self.isSelected = false
        }
    }

    private func background() {

        if bidAsk == .bid {

            let bidImage = UIColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.1).toImage()
            let bidSelectedImage = UIColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.7).toImage()
            self.setBackgroundImage(bidImage, for: .normal)
            self.setBackgroundImage(bidImage, for: .highlighted)
            self.setBackgroundImage(bidSelectedImage, for: .selected)
            self.setBackgroundImage(bidImage, for: .disabled)

        } else if bidAsk == .ask {

            let askImage = UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.1).toImage()
            let askSelectedImage = UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.7).toImage()
            self.setBackgroundImage(askImage, for: .normal)
            self.setBackgroundImage(askImage, for: .highlighted)
            self.setBackgroundImage(askSelectedImage, for: .selected)
            self.setBackgroundImage(askImage, for: .disabled)
            
        } else {
            
            self.setBackgroundImage(nil, for: .normal)
            self.setBackgroundImage(nil, for: .highlighted)
            self.setBackgroundImage(nil, for: .selected)
            self.setBackgroundImage(nil, for: .disabled)
        }
    }

}
