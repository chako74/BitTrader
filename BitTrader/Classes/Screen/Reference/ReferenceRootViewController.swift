//
//  ReferenceRootViewController.swift
//  BitTrader
//
//  Created by chako on 2016/10/11.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

class ReferenceRootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ReferenceRootViewController: BitTraderTabRootable {
    
    func setupTab() {
        self.title = "照会"
        self.tabBarItem = UITabBarItem(title: "照会", image: nil, tag: 4)
    }
}
