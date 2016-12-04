//
//  ApiExecuterProtocol.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/16.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Result

protocol ApiExecuterProtocol {

    associatedtype RequestType: RequestProtocol
    associatedtype ModelType
    associatedtype Error: Swift.Error
    typealias ResultType = Result<ModelType, Error>
    typealias ResponseConverter = (RequestType.Response) -> ModelType?

    var request: RequestType { get }
    var modelType: Any.Type { get }

    init(_ request: RequestType, responseConverter: @escaping ResponseConverter)

    func isValid(_ request: RequestType) -> Error?

    func execute()
    
    func execute(_ request: RequestType, _ callback: @escaping (ResultType) -> Void)

}

extension ApiExecuterProtocol {

    var modelType: Any.Type {
        return ModelType.self
    }
    
    func isValid(_ request: RequestType) -> Error? {
        return nil
    }
    
}
