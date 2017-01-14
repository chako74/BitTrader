//
//  ProductListViewModel.swift
//  BitTrader
//
//  Created by chako on 2017/01/09.
//  Copyright © 2017年 Bit Trader. All rights reserved.
//

import RealmSwift
import RxSwift
import RxCocoa

class ProductListViewModel {
    
    let productList: Variable<[ProductListCellModel]> = Variable([])
    
    init() {
        productList.value = makeProduct()
    }
    
    func selectedIndexpath(_ indexPath: IndexPath) {
        
        let cellModel = productList.value[indexPath.row]
        
        do {
            let realm = try Realm()
            let product = realm.objects(Product.self).filter(NSPredicate(Product.ColumnType.key.rawValue, equal: cellModel.name)).first
            if let update = product {
                try realm.write {
                    update.enabled = !cellModel.checked
                }
            }
            
            productList.value = makeProduct()
        } catch {
            
        }
    }
    
    private func makeProduct() -> [ProductListCellModel] {
        var items = [ProductListCellModel]()
        do {
            let realm = try Realm()
            realm.objects(Product.self).sorted(byProperty: Product.ColumnType.sortOrder.rawValue, ascending: true).forEach({ product in
                let cellModel = ProductListCellModel(name: product.key, checked: product.enabled)
                items.append(cellModel)
            })
            
        } catch {
            
        }
        return items
    }
}
