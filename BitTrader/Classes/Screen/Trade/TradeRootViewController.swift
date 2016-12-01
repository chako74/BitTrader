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

        // 通常
//        let navi = UINavigationController(rootViewController: SendOrderRootViewController())
        // Re版
//        let navi = UINavigationController(rootViewController: ReSendOrderRootViewController())
        // Rx版
        let navi = UINavigationController(rootViewController: RxSendOrderRootViewController())
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
