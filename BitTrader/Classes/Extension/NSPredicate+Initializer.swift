//
//  NSPredicate+Initializer.swift
//  BitTrader
//
//  Created by chako on 2017/01/12.
//  Copyright © 2017年 Bit Trader. All rights reserved.
//

import Foundation

public extension NSPredicate {
    
    public convenience init(_ property: String, equal value: Any) {
        self.init(expression: property, operation: "=", value: value)
    }
    
    public convenience init(_ property: String, notEqual value: Any) {
        self.init(expression: property, operation: "!=", value: value)
    }
    
    public convenience init(_ property: String, equalOrGreaterThan value: Any) {
        self.init(expression: property, operation: ">=", value: value)
    }
    
    public convenience init(_ property: String, equalOrLessThan value: Any) {
        self.init(expression: property, operation: "<=", value: value)
    }
    
    public convenience init(_ property: String, greaterThan value: AnyObject) {
        self.init(expression: property, operation: ">", value: value)
    }
    
    public convenience init(_ property: String, lessThan value: AnyObject) {
        self.init(expression: property, operation: "<", value: value)
    }
    
    private convenience init(expression property: String, operation: String, value: Any) {
        self.init(format: "\(property) \(operation) %@", argumentArray: [value])
    }
}
