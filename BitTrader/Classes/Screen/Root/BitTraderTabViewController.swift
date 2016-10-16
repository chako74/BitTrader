//
//  BitTraderTabViewController.swift
//  BitTrader
//
//  Created by chako on 2016/10/11.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

protocol BitTraderTabRootable {
    func setupTab()
}

class BitTraderTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func prepareViewController() {

        let viewControllers: [UIViewController] = [
            MarketRootViewController(),
            TradeRootViewController(),
            ReferenceRootViewController(),
            MenuRootViewController()
        ]
        
        viewControllers.forEach {
            if let controller = $0 as? BitTraderTabRootable {
                controller.setupTab()
            }
        }
        
        self.setViewControllers(viewControllers, animated: false)
    }
}
