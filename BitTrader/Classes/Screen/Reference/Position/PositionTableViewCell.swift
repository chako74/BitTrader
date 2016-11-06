//
//  PositionTableViewCell.swift
//  BitTrader
//
//  Created by chako on 2016/11/03.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

class PositionTableViewCell: UITableViewCell {

    @IBOutlet private weak var productLabel: UILabel?
    @IBOutlet private weak var sideLabel: UILabel?
    @IBOutlet private weak var dateLabel: UILabel?
    @IBOutlet private weak var executionPriceLabel: UILabel?
    @IBOutlet private weak var sizeLabel: UILabel?
    @IBOutlet private weak var commissionLabel: UILabel?
    @IBOutlet private weak var swapLabel: UILabel?
    @IBOutlet private weak var pnlLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(positionModel: PositionModel) {
        
        productLabel!.text = positionModel.productCode
        sideLabel!.text = positionModel.side.rawValue
        dateLabel!.text = positionModel.openDate.formatDate(fromFormat: DateFormat.iso8601, toFormat: DateFormat.openPosition)
        executionPriceLabel!.text = NSNumber(integerLiteral: positionModel.price).formatComma()
        sizeLabel!.text = NSNumber(floatLiteral: positionModel.size).formatComma()
        commissionLabel!.text = NSNumber(integerLiteral: positionModel.commission).formatComma()
        swapLabel!.text = NSNumber(integerLiteral: positionModel.swapPointAccumulate).formatComma()
        pnlLabel!.text = NSNumber(integerLiteral: positionModel.pnl).formatComma()
    }
    
}
