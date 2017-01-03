//
//  RxSendOrderGlobalModel.swift
//  BitTrader
//
//  Created by chako on 2016/12/14.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import RxCocoa
import RxSwift

class RxSendOrderGlobalModel {
    
    private let disposeBag = DisposeBag()
    private let semaphore = DispatchSemaphore(value: 1)
    fileprivate var timer: Timer?
    
    static let sharedInstance: RxSendOrderGlobalModel = {
        let instance = RxSendOrderGlobalModel()
        return instance
    }()
    
    var productCodeType: Bitflyer.ProductCodeType?
    var selectedBidAsk = Variable<Enums.BidAsk?>(nil)
    let selectedPrice = Variable<Int?>(nil)
    let bidRate = Variable<Int?>(nil)
    let askRate = Variable<Int?>(nil)
    
    let openAmount = Variable<Double?>(nil)
    
    private var subscribeCount = 0
    
    init() {
        selectedBidAsk
            .asObservable()
            .subscribe(onNext: { [weak self] bidAsk in
                if let bidAsk = bidAsk {
                    switch bidAsk {
                    case .ask:
                        self?.selectedPrice.value = self?.askRate.value
                    case .bid:
                        self?.selectedPrice.value = self?.bidRate.value
                    }
                } else {
                    self?.selectedPrice.value = nil
                }

            })
            .addDisposableTo(disposeBag)
    }
    
    func subscribe(productCodeType: Bitflyer.ProductCodeType) {
        
        self.productCodeType = productCodeType
        
        sequenceExecute {
            if subscribeCount == 0 {
                startRequest()
            }
            subscribeCount += 1
        }
    }
    
    func unsubscribe() {
        
        sequenceExecute {
            subscribeCount -= 1
            
            if subscribeCount == 0 {
                productCodeType = nil
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    private func startRequest() {
        
        SendOrderUtils.createBitflyerFxTickerRequestExecuter().execute() { [weak self] result in
            
            guard let sSelf = self else {
                return
            }
            
            switch result {
            case .success(let rateModel):
                sSelf.bidRate.value = rateModel.bidPrice
                sSelf.askRate.value = rateModel.askPrice
            case .failure:
                break
            }
            
            sSelf.startTimer()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            self?.startRequest()
        }
    }

    private func stopRequest() {
    
        timer?.invalidate()
    }
    
    private func sequenceExecute(execute: () -> ()) {
        
        semaphore.wait()
        execute()
        semaphore.signal()
    }
}
