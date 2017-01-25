//
//  RxLimitOrderViewModel.swift
//  BitTrader
//
//  Created by chako on 2016/12/24.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import RxCocoa
import RxSwift

class RxLimitOrderViewModel: ApiExecuterDelegate {
    
    let disposeBag = DisposeBag()
    
    let limitPrice = Variable<Int?>(nil)
    
    private var success: (() -> Void)?
    private var failure: ((String) -> Void)?
    
    init() {
        RxSendOrderGlobalModel.sharedInstance.selectedPrice
            .asObservable()
            .bindTo(limitPrice)
            .addDisposableTo(disposeBag)
    }
    
    deinit {
        print("deinit")
    }
    
    func setSelectedBidAsk(_ selectedBidAsk: OldEnums.BidAsk?) {
        RxSendOrderGlobalModel.sharedInstance.selectedBidAsk.value = selectedBidAsk
    }
    
    func selectedBidAsk() -> Variable<OldEnums.BidAsk?> {
        return RxSendOrderGlobalModel.sharedInstance.selectedBidAsk
    }
    
    func setOpenAmount(_ openAmount: Double?) {
        RxSendOrderGlobalModel.sharedInstance.openAmount.value = openAmount
    }
    
    func openAmount() -> Variable<Double?> {
        return RxSendOrderGlobalModel.sharedInstance.openAmount
    }
    
    func executeOrder(confirm: @escaping (_ message: String, _ cancelTitle: String, _ okTitle: String) -> Observable<String>,
                      success: @escaping () -> Void,
                      failure: @escaping (String) -> Void) throws {
        
        guard let productCode = RxSendOrderGlobalModel.sharedInstance.productCodeType else {
            throw BitTraderError.ValidationError(message: "productCodeType is required")
        }
        guard let bidAsk = selectedBidAsk().value else {
            throw BitTraderError.ValidationError(message: "bidAsk is required")
        }
        
        guard let amount = openAmount().value else {
            throw BitTraderError.ValidationError(message: "openAmount is required")
        }
        
        guard let price = limitPrice.value else {
            throw BitTraderError.ValidationError(message: "limitPrice is required")
        }
        
        if amount == 0 {
            throw BitTraderError.ValidationError(message: "数量が0です。")
        }
        
        if price == 0 {
            throw BitTraderError.ValidationError(message: "価格が0です。")
        }
        
        switch bidAsk {
        case .bid:
            if let askRate = RxSendOrderGlobalModel.sharedInstance.askRate.value {
                if price < askRate {
                    throw BitTraderError.ValidationError(message: "即時約定する可能性があります。")
                }
            }
        case .ask:
            if let bidRate = RxSendOrderGlobalModel.sharedInstance.bidRate.value {
                if bidRate < price {
                    throw BitTraderError.ValidationError(message: "即時約定する可能性があります。")
                }
            }
        }
        
        let parameter = BitflyerSendChildOrderRequestParameter(productCode: productCode,
                                                               orderType: .limit(price: price),
                                                               side: bidAsk == .bid ? Bitflyer.SideType.sell : Bitflyer.SideType.buy,
                                                               size: amount,
                                                               minuteToExpire: nil,
                                                               timeInForce: nil)
        let cancelTitle = "Cancel"
        let okTitle = "OK"
        confirm(parameter.description, cancelTitle, okTitle)
            .subscribe(onNext: { [weak self] buttonTitle in
                if buttonTitle == okTitle {
                    
                    self?.success = success
                    self?.failure = failure

                    let request = BitflyerSendChildOrderRequest(requestParameter: parameter)
                    
                    let apiExecuter = ApiKitApiExecuter<BitflyerSendChildOrderRequest, BitflyerSendChildOrderResponse>(request)
                    apiExecuter.delegate = self
                    apiExecuter.execute()
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    func success<ApiExecuter: ApiExecuterProtocol>(_ apiExecuter: ApiExecuter, value: ApiExecuter.ModelType) {
        guard let success = self.success else {
            return
        }
        
        success()
        
        self.success = nil
        self.failure = nil
    }
    
    func failure<ApiExecuter: ApiExecuterProtocol>(_ apiExecuter: ApiExecuter, error: ApiResponseError) {
        guard let failure = self.failure else {
            return
        }
        
        failure(error.message)
        
        self.success = nil
        self.failure = nil
    }
}
