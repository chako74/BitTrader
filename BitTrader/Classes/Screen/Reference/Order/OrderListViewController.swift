//
//  OrderListViewController.swift
//  BitTrader
//
//  Created by chako on 2016/11/09.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import UIKit

import ReSwift

class OrderListViewController: UIViewController, StoreSubscriber {

    @IBOutlet private weak var tableView: UITableView?
    
    let store = Store<OrderListState>(reducer:OrderListReducer(), state:nil)
    
    var orderModels = Array<OrderModel>()
    var requestTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "注文一覧"
        
        tableView!.register(UINib(nibName: String(describing: OrderListTableViewCell.self), bundle:nil), forCellReuseIdentifier: String(describing: OrderListTableViewCell.self))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        store.subscribe(self)
        
        startRequest()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        store.unsubscribe(self)
        
        super.viewDidDisappear(animated)
    }
    
    func newState(state: OrderListState) {
        
        switch state.requestStatus {
        case .none:
            break
        case .requesting:
            break
        case .requested:
            orderModels = state.orderList
            tableView?.reloadData()
            
            if let requestTimer = requestTimer {
                requestTimer.invalidate()
            }
            requestTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { [weak self] _ in
                guard let sSelf = self else {
                    return
                }
                sSelf.startRequest()
            })
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = state.isNetworkActivityIndicatorVisible()
    }
    
    func startRequest() {
        let param = GetChildOrdersParameter(productCode: ProductCodeType.fxBtcJpy,
                                            count: nil,
                                            before: nil,
                                            after: nil,
                                            childOrderState: ChildOrderState.active,
                                            parentOrderId: nil)
        store.dispatch(OrderListAction.requestOrderListAsyncAction(requestParameter: param))
    }
}

// MARK: UITableViewDataSource
extension OrderListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OrderListTableViewCell.self),
                                                 for: indexPath)
        
        if let orderTableViewCell = cell as? OrderListTableViewCell {
            orderTableViewCell.updateCell(from: orderModels[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderModels.count
    }
}

// MARK: UITableViewDelegate
extension OrderListViewController: UITableViewDelegate {
    
}
