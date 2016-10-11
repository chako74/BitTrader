//
//  MenuRootViewController.swift
//  BitTrader
//
//  Created by chako on 2016/10/11.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

class MenuRootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MenuRootViewController: BitTraderTabRootable {
    
    func setupTab() {
        self.title = "メニュー"
        self.tabBarItem = UITabBarItem(title: "メニュー", image: nil, tag: 4)
    }
}
