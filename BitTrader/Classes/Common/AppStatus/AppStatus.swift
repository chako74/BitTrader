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
        case apiKey = "Bitflyer.API.Key"
        case apiSecretKey = "Bitflyer.API.Secret.Key"
    }
    
    enum ViewType: Int {
        case registKey
        case tabMenu
    }
    
    private(set) var apiKey: String?
    private(set) var apiSecretKey: String?
    
    private(set) var viewType = Variable(ViewType.registKey)

    private let keychain = Keychain()
    
    static let sharedInstance: AppStatus = AppStatus()
    
    private init() {
        apiKey = keychain[KeyChainDataType.apiKey.rawValue]
        apiSecretKey = keychain[KeyChainDataType.apiSecretKey.rawValue]
        
        if hasApiInformation() {
            viewType.value = ViewType.tabMenu
        }
    }
    
    func updateApiInformation(apiKey: String, apiSecretKey: String) {
        
        self.apiKey = apiKey
        self.apiSecretKey = apiSecretKey
        
        keychain[KeyChainDataType.apiKey.rawValue] = apiKey
        keychain[KeyChainDataType.apiSecretKey.rawValue] = apiSecretKey
        
        if hasApiInformation() {
            viewType.value = ViewType.tabMenu
        } else {
            viewType.value = ViewType.registKey
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
