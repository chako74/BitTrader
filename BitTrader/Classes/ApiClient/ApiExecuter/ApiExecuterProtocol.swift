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
    associatedtype Error: Swift.Error
    associatedtype DTO
    typealias ResultType = Result<RequestType.Response, Error>
    typealias ResponseConverter = (RequestType.Response) -> DTO?
    typealias HTTPMethodType = String

    var request: RequestType { get }

    init(_ request: RequestType)
    init(_ request: RequestType, responseConverter: @escaping ResponseConverter)

    func isValid(_ request: RequestType) -> Error?

    func willExcecute(_ request: RequestType)

    func execute(_ request: RequestType, _ callback: @escaping (ResultType) -> Void)

    func didExcecute(_ result: ResultType)

    func onSuccess(_ response: RequestType.Response) -> DTO?

    func onFailure(_ error: Error) -> Error
}

extension ApiExecuterProtocol {

    init(_ request: RequestType, responseConverter: @escaping ResponseConverter) {
        self.init(request)
    }

    func isValid(_ request: RequestType) -> Error? {
        return nil
    }

    func willExcecute(_ request: RequestType) {
    }

    func didExcecute(_ result: ResultType) {
    }
}
