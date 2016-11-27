//
//  RateListViewModel.swift
//  BitTrader
//
//  Created by chako on 2016/10/23.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

class RateListViewModel {

    private var disposeBag = DisposeBag()
    private var rateListModel = RateListModel()
    
    let rateList: Variable<[RateModel]> = Variable([])
    var requesting: Variable<Bool> = Variable(false)
    
    func subscrive() {
        
        rateListModel.viewState
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                switch state {
                case .initial:
                    self?.requesting.value = false
                case .requesting:
                    self?.requesting.value = true
                case let .requested(rateList):
                    self?.requesting.value = false
                    self?.rateList.value = rateList
                case .error:
                    self?.requesting.value = false
                case .stop:
                    self?.requesting.value = false
                }
            })
            .addDisposableTo(disposeBag)
        
        rateListModel.fetch()
    }
    
    func unsubscrive() {
     
        rateListModel.stop()
        disposeBag = DisposeBag()
    }
}
