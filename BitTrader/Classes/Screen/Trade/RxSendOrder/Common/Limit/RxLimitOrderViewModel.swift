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
    
    func setSelectedBidAsk(_ selectedBidAsk: Enums.BidAsk?) {
        RxSendOrderGlobalModel.sharedInstance.selectedBidAsk.value = selectedBidAsk
    }
    
    func selectedBidAsk() -> Variable<Enums.BidAsk?> {
        return RxSendOrderGlobalModel.sharedInstance.selectedBidAsk
    }
    
    func setOpenAmount(_ openAmount: Double?) {
        RxSendOrderGlobalModel.sharedInstance.openAmount.value = openAmount
    }
    
    func openAmount() -> Variable<Double?> {
        return RxSendOrderGlobalModel.sharedInstance.openAmount
    }
    
    func executeOrder(success: @escaping () -> Void, failure: @escaping (String) -> Void) throws {
     
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
        
        self.success = success
        self.failure = failure
        
        let parameter = BitflyerSendChildOrderRequestParameter(productCode: productCode,
                                                               orderType: .limit(price: price),
                                                               side: bidAsk == .bid ? Bitflyer.SideType.sell : Bitflyer.SideType.buy,
                                                               size: amount,
                                                               minuteToExpire: nil,
                                                               timeInForce: nil)
        let request = BitflyerSendChildOrderRequest(requestParameter: parameter)
        
        let apiExecuter = ApiKitApiExecuter<BitflyerSendChildOrderRequest, BitflyerSendChildOrderResponse>(request)
        apiExecuter.delegate = self
        apiExecuter.execute()
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
