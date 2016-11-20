//
//  TradeRootViewController.swift
//  BitTrader
//
//  Created by chako on 2016/10/11.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

class TradeRootViewController: UIViewController, ViewContainer {

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []

        let navi = UINavigationController(rootViewController: SendOrderViewController())
        navi.navigationBar.isTranslucent = false
        addChildContainerViewController(navi)
    }
}

extension TradeRootViewController: BitTraderTabRootable {
    
    func setupTab() {
        self.title = "トレード"
        self.tabBarItem = UITabBarItem(title: "トレード", image: nil, tag: 2)
    }
}
