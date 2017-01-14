//
//  ProductListTableViewCell.swift
//  BitTrader
//
//  Created by chako on 2017/01/09.
//  Copyright © 2017年 Bit Trader. All rights reserved.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(_ cellModel: ProductListCellModel) {
        textLabel!.text = cellModel.name
        
        if cellModel.checked {
            accessoryType = .checkmark
        } else {
            accessoryType = .none
        }
    }
}
