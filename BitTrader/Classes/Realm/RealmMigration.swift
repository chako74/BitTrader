//
//  RealmMigration.swift
//  BitTrader
//
//  Created by chako on 2017/01/09.
//  Copyright © 2017年 Bit Trader. All rights reserved.
//

import Foundation
import RealmSwift

class RealmMigration {
    
    static func start() {
        let config = Realm.Configuration(
            schemaVersion: 1,
            //migrationBlock: { migration, oldSchemaVersion in
            migrationBlock: { _, oldSchemaVersion in
                // 最初のマイグレーションの場合、`oldSchemaVersion`は0です
                if oldSchemaVersion < 1 {
                    
                }
        })
        
        // デフォルトRealmに新しい設定を適用します
        Realm.Configuration.defaultConfiguration = config
    }
    
    static func initializeData() {
        
        do {
            let realm = try Realm()
            
            let canRegist = realm.objects(AppProperty.self).filter(NSPredicate("key", equal: AppProperty.KeyType.initialRealm.rawValue)).first
            if let canRegist = canRegist {
                if canRegist.value.lowercased() == true.description.lowercased() {
                    return
                }
            }
            
            // 初期値投入
            try realm.write {
                
                insertProduct(realm)
                
                let initialRealm = AppProperty()
                initialRealm.key = AppProperty.KeyType.initialRealm.rawValue
                initialRealm.value = true.description
                realm.add(initialRealm)
            }
        } catch {
        }
    }
    
    private static func insertProduct(_ realm: Realm) {

        for value in Enums.ProductType.values.enumerated() {
            let product = Product()
            product.key = value.element.rawValue
            product.enabled = true
            product.sortOrder = value.offset

            realm.add(product)
        }
    }
}
