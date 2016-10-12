//
//  Protocol.swift
//  BitTrader
//
//  Created by chako on 2016/10/12.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import UIKit

protocol ViewContainer {
    
    func addChildContainerViewController(_ addChildContainerViewController: UIViewController)
}

extension ViewContainer where Self: UIViewController {
    
    func addChildContainerViewController(_ addChildContainerViewController: UIViewController) {
        addChildViewController(addChildContainerViewController)
        view.addSubview(addChildContainerViewController.view)
        view.addFittingConstraintsFor(childView: addChildContainerViewController.view)
        addChildContainerViewController.didMove(toParentViewController: self)
    }
}
