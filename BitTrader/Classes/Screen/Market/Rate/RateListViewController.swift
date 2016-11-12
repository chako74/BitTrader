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
    private let rateListViewModel = RateListViewModel()
    
    @IBOutlet weak private var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "レート"
        
        edgesForExtendedLayout = []
        
        tableView!.register(UINib(nibName: "RateTableViewCell", bundle: nil),
                            forCellReuseIdentifier: RateListViewController.RateListCellIdentifier)

        rateListViewModel.rateList
            .asObservable()
            .bindTo(tableView!.rx.items) { tableView, _, element in
                let cell = tableView.dequeueReusableCell(withIdentifier: RateListViewController.RateListCellIdentifier)!
                if let rateCell = cell as? RateTableViewCell {
                    rateCell.update(model: element)
                }
                return cell
        }
        .addDisposableTo(disposeBag)
        
        let bitflyer = BaseApi().execute(GetBoardRequest2())
        let coincheck = BaseApi().execute(TickerRequest())

        Observable.combineLatest(bitflyer, coincheck) { ($0, $1) }
            .flatMapLatest { (bitflyer, coincheck) -> Observable<[RateViewModel]> in
                return .just([RateViewModel(rateType:.bitflyer,
                                            midPrice: Variable(bitflyer.midPrice),
                                            askPrice: Variable(bitflyer.asks[0].price),
                                            bidPrice: Variable(bitflyer.bids[0].price)),
                              RateViewModel(rateType:.coincheck,
                                            midPrice: Variable(coincheck.last),
                                            askPrice: Variable(coincheck.ask),
                                            bidPrice: Variable(coincheck.bid))
                    ])
            }
            .subscribe(onNext: { [weak self] models in
                self?.rateListViewModel.rateList.value = models
            })
            .addDisposableTo(disposeBag)


    }
}
