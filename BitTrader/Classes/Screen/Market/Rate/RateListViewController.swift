//
//  RateListViewController.swift
//  BitTrader
//
//  Created by chako on 2016/10/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

import APIKit
import RxCocoa
import RxSwift

class RateListViewController: UIViewController {

    private static let RateListCellIdentifier = "RateListCell"

    private let disposeBag = DisposeBag()
    private var rateListViewModel = RateListViewModel()

    @IBOutlet weak private var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "レート"

        edgesForExtendedLayout = []

        tableView!.register(UINib(nibName: "RateTableViewCell", bundle: nil),
                            forCellReuseIdentifier: RateListViewController.RateListCellIdentifier)

        rateListViewModel.rateList
            .asDriver()
            .drive(tableView!.rx.items) { tableView, _, element in
                let cell = tableView.dequeueReusableCell(withIdentifier: RateListViewController.RateListCellIdentifier)!
                if let rateCell = cell as? RateTableViewCell {
                    rateCell.update(model: element)
                }
                return cell
            }
            .addDisposableTo(disposeBag)
        
        // TODO: Rxのintervalの間を検知できていない
        rateListViewModel.requesting
            .asDriver()
            .drive(onNext: { requesting in
                UIApplication.shared.isNetworkActivityIndicatorVisible = requesting
            })
            .addDisposableTo(disposeBag)
        
        viewDidAppearTrigger
            .subscribe(onNext: { [weak self] _ in
                self?.rateListViewModel.subscrive()
        })
        .addDisposableTo(disposeBag)
        
        viewDidDisappearTrigger
            .subscribe(onNext: { [weak self] _ in
                self?.rateListViewModel.unsubscrive()
        })
        .addDisposableTo(disposeBag)
    }
    
    private func trigger(selector: Selector) -> Observable<Void> {
        return rx.sentMessage(selector).map { _ in () }.shareReplay(1)
    }
    
    var viewWillAppearTrigger: Observable<Void> {
        return trigger(selector: #selector(self.viewWillAppear(_:)))
    }
    
    var viewDidAppearTrigger: Observable<Void> {
        return trigger(selector: #selector(self.viewDidAppear(_:)))
    }
    
    var viewWillDisappearTrigger: Observable<Void> {
        return trigger(selector: #selector(self.viewWillDisappear(_:)))
    }
    
    var viewDidDisappearTrigger: Observable<Void> {
        return trigger(selector: #selector(self.viewDidDisappear(_:)))
    }
}
