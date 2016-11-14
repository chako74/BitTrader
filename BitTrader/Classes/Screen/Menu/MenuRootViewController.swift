//
//  MenuRootViewController.swift
//  BitTrader
//
//  Created by chako on 2016/10/11.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MenuRootViewController: UIViewController, ViewContainer {
    
    private var activeViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navi = UINavigationController(rootViewController: MenuListViewController())
        navi.navigationBar.isTranslucent = false
        addChildContainerViewController(navi)
        activeViewController = navi
    }
}

extension MenuRootViewController: BitTraderTabRootable {
    
    func setupTab() {
        self.title = "メニュー"
        self.tabBarItem = UITabBarItem(title: "メニュー", image: nil, tag: 4)
    }
}
