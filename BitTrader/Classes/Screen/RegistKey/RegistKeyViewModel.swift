//
//  RegistKeyViewModel.swift
//  BitTrader
//
//  Created by chako on 2016/10/11.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

struct RegistKeyViewModel {
    
    let apiKey = Variable("")
    let apiSecretKey = Variable("")
    let enableSettingButton: Observable<Bool>
    
    init() {
        if let apiKey = AppStatus.sharedInstance.apiKey {
            self.apiKey.value = apiKey
        }
        if let apiSecretKey = AppStatus.sharedInstance.apiSecretKey {
            self.apiSecretKey.value = apiSecretKey
        }
        
        self.enableSettingButton =
            Observable.combineLatest(self.apiKey.asObservable(),
                                     self.apiSecretKey.asObservable()) {
                                        !$0.0.isEmpty && !$0.1.isEmpty
        }
    }
    
    func registApiKeyInformation() {
        AppStatus.sharedInstance.updateApiInformation(apiKey: self.apiKey.value,
                                                      apiSecretKey: self.apiSecretKey.value)
    }
}
