//
//  RootViewController.swift
//  BitTrader
//
//  Created by chako on 2016/10/07.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

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
        let loginViewController = LoginViewController()
        addChildContainerViewController(loginViewController)
        
        activeViewController = loginViewController
    }
}

// MARK: Container Method
extension RootViewController {
    
    func addChildContainerViewController(_ addChildContainerViewController: UIViewController) {
        addChildViewController(addChildContainerViewController)
        view.addSubview(addChildContainerViewController.view)
        addChildContainerViewController.didMove(toParentViewController: self)
    }
}
