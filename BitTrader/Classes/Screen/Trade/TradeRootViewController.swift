//
//  TradeRootViewController.swift
//  BitTrader
//
//  Created by chako on 2016/10/11.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

class TradeRootViewController: UIViewController, ViewContainer {

    private var activeViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []

        let navi = UINavigationController(rootViewController: SendOrderRootViewController())
        navi.navigationBar.isTranslucent = false
        addChildContainerViewController(navi)
        activeViewController = navi
    }
}

extension TradeRootViewController: BitTraderTabRootable {
    
    func setupTab() {
        self.title = "トレード"
        self.tabBarItem = UITabBarItem(title: "トレード", image: nil, tag: 2)
    }
}
