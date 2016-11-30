//
//  ApiExecuterProtocol.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/16.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Result

protocol ApiExecuterDelegate: NSObjectProtocol {
    func onSuccess<ApiExecuter: ApiExecuterProtocol>(_ apiExecuter: ApiExecuter, value: ApiExecuter.ModelType)
    func onFailure<ApiExecuter: ApiExecuterProtocol>(_ apiExecuter: ApiExecuter, error: ApiResponseError)
}

protocol ApiExecuterProtocol {

    var delegate: ApiExecuterDelegate? { get }

    associatedtype RequestType: RequestProtocol
    associatedtype ModelType
    associatedtype Error: Swift.Error
    typealias ResultType = Result<RequestType.Response, Error>
    typealias ResponseConverter = (RequestType.Response) -> ModelType?

    var request: RequestType { get }
    var modelType: Any.Type { get }

    init(_ request: RequestType, responseConverter: @escaping ResponseConverter)

    func isValid(_ request: RequestType) -> Error?

    func willExcecute(_ request: RequestType)

    func execute()
    
    func execute(_ request: RequestType, _ callback: @escaping (ResultType) -> Void)

    func didExcecute(_ result: Any)

    func onSuccess(_ response: RequestType.Response) -> ModelType

    func onFailure(_ error: Error) -> Error
}

extension ApiExecuterProtocol {

    var modelType: Any.Type {
        return ModelType.self
    }
    
    func isValid(_ request: RequestType) -> Error? {
        return nil
    }

    func willExcecute(_ request: RequestType) {
    }

    func execute() {
    }

    func execute(_ request: RequestType, _ callback: @escaping (ResultType) -> Void) {
    }

    func didExcecute(_ result: Any) {
    }
}
