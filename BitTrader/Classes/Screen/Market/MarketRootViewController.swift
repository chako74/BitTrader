//
//  MarketRootViewController.swift
//  BitTrader
//
//  Created by chako on 2016/10/11.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

class MarketRootViewController: UIViewController, ViewContainer {

    private var activeViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let sb = UIStoryboard.init(name: "RateList", bundle: nil)
        if let rateViewController = sb.instantiateInitialViewController() {
            addChildContainerViewController(rateViewController)
            activeViewController = rateViewController
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MarketRootViewController: BitTraderTabRootable {

    func setupTab() {
        self.title = "マーケット"
        self.tabBarItem = UITabBarItem(title: "マーケット", image: nil, tag: 1)
    }
}
