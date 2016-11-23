//
//  ApiKitApiExecuter.swift
//  BitTrader
//
//  Created by coaractos on 2016/11/16.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import APIKit
import Himotoki
import Result

class ApiKitApiExecuter<RequestType: ApiKitRequestProtocol, DTO>: ApiKitApiExecuterProtocol {

    weak var delegate: ApiExecuterDelegate?

    typealias Error = SessionTaskError
    typealias ResultType = Result<RequestType.Response, Error>
    typealias ResponseConverter = (RequestType.Response) -> DTO?

    private let _request: RequestType
    private var _responseConverter: ResponseConverter = { r in r as? DTO }

    required init(_ request: RequestType) {
        _request = request
    }

    required init(_ request: RequestType, responseConverter: @escaping ResponseConverter) {
        _request = request
        _responseConverter = responseConverter
    }

    var request: RequestType {
        return _request
    }

    func execute(_ request: RequestType, _ callback: @escaping (ResultType) -> Void) {
        Session.send(ApiKitRequestAdapter(request)) { result in
            callback(result)
        }
    }

    func onSuccess(_ response: RequestType.Response) -> DTO? {
        return _responseConverter(response)
    }

    func onFailure(_ error: Error) -> Error {
        return error
    }

}

class ApiKitRequestAdapter<RequestType: ApiKitRequestProtocol> : Request {

    typealias Response = RequestType.Response

    private let _request: RequestType

    init(_ request: RequestType) {
        _request = request
    }

    var baseURL: URL {
        return _request.baseURL
    }

    var method: HTTPMethod {
        return _request.method
    }

    var path: String {
        return _request.path
    }

    var parameters: Any? {
        return _request.parameters
    }

    public var queryParameters: [String : Any]? {
        return _request.queryParameters
    }

    public var bodyParameters: BodyParameters? {
        return _request.bodyParameters
    }

    public var headerFields: [String : String] {
        return _request.headerFields
    }

    public var dataParser: DataParser {
        return _request.dataParser
    }

    public func intercept(urlRequest: URLRequest) throws -> URLRequest {
        return try _request.intercept(urlRequest: urlRequest)
    }

    public func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        return try _request.intercept(object: object, urlResponse: urlResponse)
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try _request.response(from: object, urlResponse: urlResponse)
    }
}
