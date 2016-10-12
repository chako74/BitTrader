//
//  RootViewController.swift
//  BitTrader
//
//  Created by chako on 2016/10/07.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, ViewContainer {

    // MARK: member
    var activeViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func prepareViewController() {
        
        if AppStatus.sharedInstance.hasApiInformation() {
            let tabBarController = BitTraderTabViewController()
            addChildContainerViewController(tabBarController)
            activeViewController = tabBarController
        } else {
            let registKeyViewController = RegistKeyViewController()
            addChildContainerViewController(registKeyViewController)
            activeViewController = registKeyViewController
        }
    }
}
