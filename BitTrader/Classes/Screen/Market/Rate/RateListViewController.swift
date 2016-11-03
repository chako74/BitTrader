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
        
        let rxTimer = Observable<Int>
            .interval(3.0, scheduler: MainScheduler.instance)
            .startWith(0)
            .shareReplay(1)
        
        let backgroundScheduler = SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .default)
        rxTimer
            .subscribeOn(backgroundScheduler)
            .flatMap {_ -> Observable<GetBoardRequest.Response> in
                let request = GetBoardRequest(requestParameter: GetBoardRequestParameter(productCode: .fxBtcJpy))
                return Session.rx_sendRequest(request: request)
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                let model = RateViewModel(rateType:.bitflyer,
                                          midPrice: Variable(response.midPrice),
                                          askPrice: Variable(response.asks[0].price),
                                          bidPrice: Variable(response.bids[0].price))
                                          
                self?.rateListViewModel.rateList.value = [model]
                })
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
