//
//  RootViewController.swift
//  BitTrader
//
//  Created by chako on 2016/10/07.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class RootViewController: UIViewController, ViewContainer {

    private let disposeBag = DisposeBag()
    
    var activeViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareViewController()
        
        AppStatus.sharedInstance.viewType.asObservable().subscribe(onNext: { [weak self] viewType in
            
            if let active = self?.activeViewController {
                switch viewType {
                case .registKey:
                    if type(of: active) != RegistKeyViewController.self {
                        self?.removeChildContainerViewController(active)
                        let registKeyViewController = RegistKeyViewController()
                        self?.addChildContainerViewController(registKeyViewController)
                        self?.activeViewController = registKeyViewController
                    }
                case .tabMenu:
                    if type(of: active) != BitTraderTabViewController.self {
                        self?.removeChildContainerViewController(active)
                        let bitTraderTabViewController = BitTraderTabViewController()
                        self?.addChildContainerViewController(bitTraderTabViewController)
                        self?.activeViewController = bitTraderTabViewController
                    }
                }
            }
            })
        .addDisposableTo(disposeBag)
    }

    func prepareViewController() {
        
        switch AppStatus.sharedInstance.viewType.value {
        case .registKey:
            let registKeyViewController = RegistKeyViewController()
            addChildContainerViewController(registKeyViewController)
            activeViewController = registKeyViewController

        case .tabMenu:
            let tabBarController = BitTraderTabViewController()
            addChildContainerViewController(tabBarController)
            activeViewController = tabBarController
        }
    }
}
