//
//  OrderListTableViewCell.swift
//  BitTrader
//
//  Created by chako on 2016/11/13.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {

    @IBOutlet private weak var productLabel: UILabel?
    @IBOutlet private weak var sideLabel: UILabel?
    @IBOutlet private weak var dateLabel: UILabel?
    @IBOutlet private weak var sizeLabel: UILabel?
    @IBOutlet private weak var executedSizeLabel: UILabel?
    @IBOutlet private weak var priceLabel: UILabel?
    @IBOutlet private weak var averagePriceLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell(from orderModel: OrderModel) {
        productLabel?.text = orderModel.productCode.rawValue
        sideLabel?.text = orderModel.side.rawValue
        dateLabel?.text = orderModel.childOrderDate.formatDate(fromFormat: .iso8601, toFormat: .cell)
        sizeLabel?.text = NSNumber(floatLiteral: orderModel.size).formatComma()
        executedSizeLabel?.text = NSNumber(integerLiteral: orderModel.executedSize).formatComma()
        priceLabel?.text = NSNumber(integerLiteral: orderModel.price).formatComma()
        averagePriceLabel?.text = NSNumber(integerLiteral: orderModel.averagePrice).formatComma()
    }
}
