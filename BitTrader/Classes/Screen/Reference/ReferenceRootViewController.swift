//
//  ReferenceRootViewController.swift
//  BitTrader
//
//  Created by chako on 2016/10/11.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

class ReferenceRootViewController: UIViewController, ViewContainer {

    private var activeViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pager = PagerViewController()
        let navi = UINavigationController(rootViewController: pager)
        addChildContainerViewController(navi)
        
        pager.pageViewControllers = [PositionListViewController(), OrderListViewController()]
        pager.currentPage = 0

        activeViewController = navi
    }
}

extension ReferenceRootViewController: BitTraderTabRootable {
    
    func setupTab() {
        self.title = "照会"
        self.tabBarItem = UITabBarItem(title: "照会", image: nil, tag: 4)
    }
}
