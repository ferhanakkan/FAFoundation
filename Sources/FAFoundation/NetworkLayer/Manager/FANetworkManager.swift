//
//  FANetworkManager.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import UIKit

public typealias FANetworkCompletion<Response: Decodable> = (Result<FANetworkResponse<Response>, FANetworkError>) -> Void

typealias FAServiceCompletion<Response: Decodable> = (Result<Response, FANetworkError>) -> Void

typealias FAServiceCompletionStatusCode<Response: Decodable> = (Result<(response: Response, status: HTTPStatus), FANetworkError>) -> Void

public protocol FANetworkManagerProtocol {
    static var shared: FANetworkManagerProtocol { get }
    var reachability: FAReachabilityManagerProtocol { get }

    @discardableResult
    func genericFetch<EndpointType: FAEndpoint>(queue: DispatchQueue,
                                                _ endpoint: EndpointType,
                                                completion: @escaping FANetworkCompletion<EndpointType.ResponseType>) -> URLSessionTask?
}

public extension FANetworkManagerProtocol {
    @discardableResult
    func genericFetch<EndpointType: FAEndpoint>(_ endpoint: EndpointType,
                                                completion: @escaping FANetworkCompletion<EndpointType.ResponseType>) -> URLSessionTask? {
        genericFetch(queue: .main, endpoint, completion: completion)
    }

    static var shared: FANetworkManagerProtocol {
        FANetworkManager.shared
    }

    var reachability: FAReachabilityManagerProtocol {
        FANetworkManager.shared.reachability
    }
}

struct FANetworkManager: FANetworkManagerProtocol {
    static let shared: FANetworkManager = .init()
    public let reachability = FAReachabilityManager()

    func genericFetch<EndpointType: FAEndpoint>(queue: DispatchQueue = .main,
                                                _ endpoint: EndpointType,
                                                completion: @escaping FANetworkCompletion<EndpointType.ResponseType>) -> URLSessionTask? {
        genericFetch(endpoint) { result in
            queue.safeAsync {
                completion(result)
            }
        }
    }

    private func genericFetch<EndpointType: FAEndpoint>(_ endpoint: EndpointType,
                                                        completion: @escaping FANetworkCompletion<EndpointType.ResponseType>) -> URLSessionTask? {
        let task = FATRouter().request(endpoint, timeout: endpoint.timeout) { data, response, error in
            guard error == nil, let data = data else {
                completion(.failure(.serviceError))
                return
            }
            if let response = response as? HTTPURLResponse {
                do {
                    let networkResponse = try FANetworkResponse<EndpointType.ResponseType>(urlResponse: response, with: data)

                    completion(.success(networkResponse))
                } catch {
                    print(error)
                    completion(.failure(.decodingError(data)))
                }
            } else {
                /// - TODO: Chechk if response allways can be converted to HTTPURLResponse
                completion(.failure(.serviceError))
            }
        }
        return task
    }
}
