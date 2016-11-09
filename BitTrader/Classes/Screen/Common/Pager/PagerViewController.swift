//
//  PagerViewController.swift
//  BitTrader
//
//  Created by chako on 2016/11/08.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class PagerViewController: UIViewController, ViewContainer {

    @IBOutlet private weak var page: UIPageControl!
    @IBOutlet private weak var containerView: UIView!
    
    private let disposeBag = DisposeBag()
    
    private(set) var activeViewController: UIViewController? {
        didSet {
            self.title = activeViewController?.title
        }
    }
    
    var pageViewControllers: Array<UIViewController>? {
        didSet {
            updatePages()
        }
    }
    
    var currentPage: Int = 0 {
        willSet {
            if currentPage != newValue {
                if let active = activeViewController {
                    removeChildContainerViewController(active)
                    activeViewController = nil
                }
            }
        }
        didSet {
            updateCurrentPage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        
        setupPage()
        
        page!.rx.controlEvent(UIControlEvents.valueChanged)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                if let sSelf = self {
                    if let active = sSelf.activeViewController {
                        sSelf.removeChildContainerViewController(active)
                        sSelf.activeViewController = nil
                    }
                    if let pages = sSelf.pageViewControllers {
                        if sSelf.page!.currentPage < pages.count {
                            let page = sSelf.page!.currentPage
                            let viewController = pages[page]
                            sSelf.addChildContainerViewController(viewController, atContainerView: sSelf.containerView)
                            sSelf.activeViewController = viewController
                        }
                    }
                }

            })
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupPage() {
        updatePages()
        updateCurrentPage()
    }
    
    private func updatePages() {
        if let pageViewControllers = pageViewControllers {
            page?.numberOfPages = pageViewControllers.count
        } else {
            page?.numberOfPages = 0
        }
    }
    
    private func updateCurrentPage() {
        if let pageControl = page, let pages = pageViewControllers {
            pageControl.currentPage = currentPage
            if currentPage < pages.count {
                let viewController = pages[currentPage]
                addChildContainerViewController(viewController, atContainerView: containerView!)
                activeViewController = viewController
            }
        }
    }
}
