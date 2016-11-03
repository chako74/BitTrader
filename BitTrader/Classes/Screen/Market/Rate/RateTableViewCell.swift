//
//  RateTableViewCell.swift
//  BitTrader
//
//  Created by chako on 2016/10/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

class RateTableViewCell: UITableViewCell {

    @IBOutlet private weak var rateTypeLabel: UILabel?
    @IBOutlet private weak var midPriceLabel: UILabel?
    @IBOutlet private weak var askPriceLabel: UILabel?
    @IBOutlet private weak var bidPriceLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(model: RateViewModel) {
        rateTypeLabel!.text = model.rateType.text()
        midPriceLabel!.text = NSNumber(integerLiteral: model.midPrice.value).formatComma()
        askPriceLabel!.text = NSNumber(integerLiteral: model.askPrice.value).formatComma()
        bidPriceLabel!.text = NSNumber(integerLiteral: model.bidPrice.value).formatComma()
    }
}
