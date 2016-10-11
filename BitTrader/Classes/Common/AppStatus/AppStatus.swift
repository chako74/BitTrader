//
//  AppStatus.swift
//  BitTrader
//
//  Created by chako on 2016/10/07.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import KeychainAccess

class AppStatus {
    
    enum KeyChainDataType: String {
        case ApiKey = "Bitflyer.API.Key"
        case ApiSecretKey = "Bitflyer.API.Secret.Key"
    }
    
    private(set) var apiKey: String?
    private(set) var apiSecretKey: String?

    private let keychain = Keychain()
    
    static let sharedInstance: AppStatus = AppStatus()
    
    private init() {
        apiKey = keychain[KeyChainDataType.ApiKey.rawValue]
        apiSecretKey = keychain[KeyChainDataType.ApiSecretKey.rawValue]
    }
    
    func updateApiInformation(apiKey: String, apiSecretKey: String) {
        
        self.apiKey = apiKey
        self.apiSecretKey = apiSecretKey
        
        keychain[KeyChainDataType.ApiKey.rawValue] = apiKey
        keychain[KeyChainDataType.ApiSecretKey.rawValue] = apiSecretKey
    }
}
