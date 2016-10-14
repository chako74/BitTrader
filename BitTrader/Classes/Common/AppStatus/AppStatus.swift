//
//  AppStatus.swift
//  BitTrader
//
//  Created by chako on 2016/10/07.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import KeychainAccess

import RxCocoa
import RxSwift

class AppStatus {
    
    enum KeyChainDataType: String {
        case ApiKey = "Bitflyer.API.Key"
        case ApiSecretKey = "Bitflyer.API.Secret.Key"
    }
    
    enum ViewType: Int {
        case RegistKey
        case TabMenu
    }
    
    private(set) var apiKey: String?
    private(set) var apiSecretKey: String?
    
    private(set) var viewType = Variable(ViewType.RegistKey)

    private let keychain = Keychain()
    
    static let sharedInstance: AppStatus = AppStatus()
    
    private init() {
        apiKey = keychain[KeyChainDataType.ApiKey.rawValue]
        apiSecretKey = keychain[KeyChainDataType.ApiSecretKey.rawValue]
        
        if hasApiInformation() {
            viewType.value = ViewType.TabMenu
        }
    }
    
    func updateApiInformation(apiKey: String, apiSecretKey: String) {
        
        self.apiKey = apiKey
        self.apiSecretKey = apiSecretKey
        
        keychain[KeyChainDataType.ApiKey.rawValue] = apiKey
        keychain[KeyChainDataType.ApiSecretKey.rawValue] = apiSecretKey
        
        if hasApiInformation() {
            viewType.value = ViewType.TabMenu
        } else {
            viewType.value = ViewType.RegistKey
        }
    }
    
    private func hasApiInformation() -> Bool {
        
        if let apiKey = self.apiKey, let apiSecretKey = self.apiSecretKey {
            return !apiKey.isEmpty && !apiSecretKey.isEmpty
        } else {
            return false
        }
    }
}
