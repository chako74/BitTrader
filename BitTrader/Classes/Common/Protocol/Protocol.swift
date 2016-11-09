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
    func addChildContainerViewController(_ addChildContainerViewController: UIViewController, atContainerView: UIView)
    func removeChildContainerViewController(_ removeChildContainerViewController: UIViewController)
}

extension ViewContainer where Self: UIViewController {
    
    func addChildContainerViewController(_ addChildContainerViewController: UIViewController) {
        self.addChildContainerViewController(addChildContainerViewController, atContainerView: self.view!)
    }
    
    func addChildContainerViewController(_ addChildContainerViewController: UIViewController, atContainerView: UIView) {
        addChildViewController(addChildContainerViewController)
        atContainerView.addSubview(addChildContainerViewController.view)
        atContainerView.addFittingConstraintsFor(childView: addChildContainerViewController.view)
        addChildContainerViewController.didMove(toParentViewController: self)
    }
    
    func removeChildContainerViewController(_ removeChildContainerViewController: UIViewController) {
        removeChildContainerViewController.willMove(toParentViewController: nil)
        removeChildContainerViewController.view.removeFromSuperview()
        removeChildContainerViewController.removeFromParentViewController()
    }
}
