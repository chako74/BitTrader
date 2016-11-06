//
//  PositionListViewController.swift
//  BitTrader
//
//  Created by chako on 2016/11/03.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit
import APIKit
import RxCocoa
import RxSwift

class PositionListViewController: UIViewController {

    private static let PositionListCellIdentifier = "PositionListCell"
    
    private let disposeBag = DisposeBag()
    private let positionListViewModel = PositionListViewModel()
    
    @IBOutlet var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "建玉一覧"
        
        edgesForExtendedLayout = []
        
        tableView?.register(UINib(nibName:"PositionTableViewCell", bundle:nil),
                            forCellReuseIdentifier: PositionListViewController.PositionListCellIdentifier)
        
        positionListViewModel.positionList
            .asDriver()
            .drive(tableView!.rx.items(cellIdentifier: PositionListViewController.PositionListCellIdentifier,
                                       cellType: PositionTableViewCell.self)) { (_, viewModel, cell) in
                                        cell.update(positionModel: viewModel)
            }
            .addDisposableTo(disposeBag)

        let rxTimer = Observable<Int>
            .interval(3.0, scheduler: MainScheduler.instance)
            .startWith(0)
            .shareReplay(1)
        
        let backgroundScheduler = SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .default)
        rxTimer
            .subscribeOn(backgroundScheduler)
            .flatMap {_ -> Observable<GetPositionsRequest.Response> in
                let request = GetPositionsRequest(requestParameter: GetPositionsParameter())
                return Session.rx_sendRequest(request: request)
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                self?.positionListViewModel.positionList.value = response.positionModels
            })
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
