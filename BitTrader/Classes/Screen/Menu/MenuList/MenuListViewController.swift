//
//  MenuListViewController.swift
//  BitTrader
//
//  Created by chako on 2016/10/12.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class MenuListViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let menuListViewModel = MenuListViewModel()
    
    @IBOutlet weak private var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
        
        menuListViewModel.menus
            .asObservable()
            .bindTo(tableView!.rx.items) { tableView, _, element in
                let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell")!
                cell.textLabel?.text = element
                return cell
            }
            .addDisposableTo(disposeBag)
        
        tableView!
            .rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.move(to: indexPath)
                self?.tableView!.cellForRow(at: indexPath)?.isSelected = false
                })
            .addDisposableTo(disposeBag)
        
        //        tableView!
        //            .rx.itemDeselected
        //            .subscribe(onNext: { [weak self] indexPath in
        //                self?.tableView!.cellForRow(at: indexPath)?.isSelected = false
        //                })
        //            .addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func move(to indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(BTCChangerViewController(), animated: true)
        default:
            break
        }
    }
}
