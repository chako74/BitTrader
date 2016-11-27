//
//  RateTableViewCell.swift
//  BitTrader
//
//  Created by chako on 2016/10/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

class RateTableViewCell: UITableViewCell {

    @IBOutlet private weak var rateTypeLabel: UILabel!
    @IBOutlet private weak var midPriceLabel: UILabel! {
        didSet {
            midPriceLabel.font = midPriceLabel.font.monospacedDigitFont
        }
    }
    @IBOutlet private weak var askPriceLabel: UILabel! {
        didSet {
            askPriceLabel.font = askPriceLabel.font.monospacedDigitFont
        }
    }
    @IBOutlet private weak var bidPriceLabel: UILabel! {
        didSet {
            bidPriceLabel.font = bidPriceLabel.font.monospacedDigitFont
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(model: RateModel) {
        rateTypeLabel!.text = model.rateType.text()
        midPriceLabel!.text = NSNumber(integerLiteral: model.midPrice).formatComma()
        askPriceLabel!.text = NSNumber(integerLiteral: model.askPrice).formatComma()
        bidPriceLabel!.text = NSNumber(integerLiteral: model.bidPrice).formatComma()
    }
}
