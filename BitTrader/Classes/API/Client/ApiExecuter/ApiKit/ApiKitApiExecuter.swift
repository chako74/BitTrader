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

protocol ApiExecuterDelegate {
    func success<ApiExecuter: ApiExecuterProtocol>(_ apiExecuter: ApiExecuter, value: ApiExecuter.ModelType)
    func failure<ApiExecuter: ApiExecuterProtocol>(_ apiExecuter: ApiExecuter, error: ApiResponseError)
}

protocol ApiExecuterSubscriber {
    associatedtype ApiExecuter: ApiExecuterProtocol
    func success(value: ApiExecuter.ModelType)
    func failure(error: ApiResponseError)
}

class ApiKitApiExecuter<RequestType: ApiKitRequestProtocol, ModelType>: ApiExecuterProtocol {

    var delegate: ApiExecuterDelegate?

    typealias Error = ApiResponseError
    typealias ResultType = Result<ModelType, Error>
    typealias ResponseConverter = (RequestType.Response) -> ModelType?
    typealias CallbackType = (ResultType) -> Void

    private let _request: RequestType
    private var _responseConverter: ResponseConverter

    required init(_ request: RequestType, responseConverter: @escaping ResponseConverter = { r in r as? ModelType }) {
        _request = request
        _responseConverter = responseConverter
    }

    var request: RequestType {
        return _request
    }

    func execute() {
        execute(request) { result in
            switch result {
            case .success(let response):
                self.delegate?.success(self, value: response)
            case .failure(let error):
                self.delegate?.failure(self, error: error)
            }
        }
    }

    func execute(callback: @escaping CallbackType) {
        execute(request, callback)
    }

    func execute<ApiExecuter: ApiExecuterProtocol, API: ApiExecuterSubscriber>(_ api: API)
        where API.ApiExecuter == ApiExecuter, API.ApiExecuter.ModelType == ModelType, ApiExecuter.ModelType == ModelType {
            execute(request) { result in
                switch result {
                case .success(let response):
                    api.success(value: response)
                case .failure(let error):
                    api.failure(error: error)
                }
            }
    }

    func execute(_ request: RequestType, _ callback: @escaping CallbackType) {

        if let error = isValid(request) {
            callback(.failure(error))
            return
        }

        Session.send(ApiKitRequestAdapter(request)) { result in
            switch result {
            case .success(let response):
                callback(.success(self._responseConverter(response)!))
            case .failure(.responseError(let apiResponseError as ApiResponseError)):
                callback(.failure(apiResponseError))
            default:
                fatalError("can't convert response.")
            }
        }
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
