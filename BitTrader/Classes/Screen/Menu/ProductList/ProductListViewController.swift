//
//  ProductListViewController.swift
//  BitTrader
//
//  Created by chako on 2017/01/09.
//  Copyright © 2017年 Bit Trader. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class ProductListViewController: UIViewController {
    
    private static let ProductListCellIdentifier = "ProductListTableViewCell"
    
    private let disposeBag = DisposeBag()
    private let viewModel = ProductListViewModel()
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "銘柄一覧"
        
        edgesForExtendedLayout = []
        
        tableView.register(UINib(nibName:"ProductListTableViewCell", bundle: nil),
                           forCellReuseIdentifier: ProductListViewController.ProductListCellIdentifier)

        bindTable()
        bindViewModel()
    }
    
    private func bindTable() {
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.selectedIndexpath(indexPath)
                self?.tableView.reloadData()
            })
            .addDisposableTo(disposeBag)

    }
    
    private func bindViewModel() {
        viewModel.productList
            .asDriver()
            .drive(tableView.rx.items(cellIdentifier: ProductListViewController.ProductListCellIdentifier,
                                      cellType: ProductListTableViewCell.self)) { (_, cellModel, cell) in
                                        cell.update(cellModel)
            }
            .addDisposableTo(disposeBag)
    }
}
