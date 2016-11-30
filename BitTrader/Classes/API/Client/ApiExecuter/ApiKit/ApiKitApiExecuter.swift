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

class ApiKitApiExecuter<RequestType: ApiKitRequestProtocol, ModelType>: ApiKitApiExecuterProtocol {

    weak var delegate: ApiExecuterDelegate?

    typealias Error = ApiResponseError
    typealias ResultType = Result<RequestType.Response, Error>
    typealias ResponseConverter = (RequestType.Response) -> ModelType?

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

        if let error = isValid(request) {
            delegate?.onFailure(self, error: onFailure(error))
            return
        }

        willExcecute(request)

        Session.send(ApiKitRequestAdapter(request)) { result in

            self.didExcecute(result)

            switch result {
            case .success(let res):
                self.delegate?.onSuccess(self, value: self.onSuccess(res))
            case .failure(.responseError(let apiResponseError as ApiResponseError)):
                self.delegate?.onFailure(self, error: self.onFailure(apiResponseError))
            default:
                fatalError("can't convert response.")
            }
        }
    }

    func execute(_ request: RequestType, _ callback: @escaping (ResultType) -> Void) {
        Session.send(ApiKitRequestAdapter(request)) { result in
            switch result {
            case .success(let res):
                callback(.success(res))
            case .failure(.responseError(let apiResponseError as ApiResponseError)):
                callback(.failure(apiResponseError))
            default:
                fatalError("can't convert response.")
            }
        }
    }

    func onSuccess(_ response: RequestType.Response) -> ModelType {
        return _responseConverter(response)!
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
