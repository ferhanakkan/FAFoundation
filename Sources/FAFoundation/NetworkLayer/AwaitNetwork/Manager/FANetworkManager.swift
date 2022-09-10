//
//  FAAwaitNetworkManager.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import UIKit

public typealias FAAwaitNetworkCompletion<Response: Decodable> = (Result<FAAwaitNetworkResponse<Response>, FAAwaitNetworkError>) -> Void

typealias FAAwaitServiceCompletion<Response: Decodable> = (Result<Response, FAAwaitNetworkError>) -> Void

typealias FAAwaitServiceCompletionStatusCode<Response: Decodable> = (Result<(response: Response, status: HTTPStatus), FAAwaitNetworkError>) -> Void

public protocol FAAwaitNetworkManagerProtocol {
    static var shared: FAAwaitNetworkManagerProtocol { get }
    var reachability: FAAwaitReachabilityManagerProtocol { get }

    @discardableResult
    func genericFetch<EndpointType: FAAwaitEndpoint>(queue: DispatchQueue,
                                                _ endpoint: EndpointType,
                                                completion: @escaping FAAwaitNetworkCompletion<EndpointType.ResponseType>) -> URLSessionTask?
}

public extension FAAwaitNetworkManagerProtocol {
    @discardableResult
    func genericFetch<EndpointType: FAAwaitEndpoint>(_ endpoint: EndpointType,
                                                completion: @escaping FAAwaitNetworkCompletion<EndpointType.ResponseType>) -> URLSessionTask? {
        genericFetch(queue: .main, endpoint, completion: completion)
    }

    static var shared: FAAwaitNetworkManagerProtocol {
        FAAwaitNetworkManager.shared
    }

    var reachability: FAAwaitReachabilityManagerProtocol {
        FAAwaitNetworkManager.shared.reachability
    }
}

struct FAAwaitNetworkManager: FAAwaitNetworkManagerProtocol {
    static let shared: FAAwaitNetworkManager = .init()
    public let reachability = FAAwaitReachabilityManager()

    func genericFetch<EndpointType: FAAwaitEndpoint>(queue: DispatchQueue = .main,
                                                _ endpoint: EndpointType,
                                                completion: @escaping FAAwaitNetworkCompletion<EndpointType.ResponseType>) -> URLSessionTask? {
        genericFetch(endpoint) { result in
            queue.safeAsync {
                completion(result)
            }
        }
    }

    private func genericFetch<EndpointType: FAAwaitEndpoint>(_ endpoint: EndpointType,
                                                        completion: @escaping FAAwaitNetworkCompletion<EndpointType.ResponseType>) -> URLSessionTask? {
        let task = FAAwaitTRouter().request(endpoint, timeout: endpoint.timeout) { data, response, error in
            guard error == nil, let data = data else {
                completion(.FAAwaitilure(.serviceError))
                return
            }
            if let response = response as? HTTPURLResponse {
                do {
                    let networkResponse = try FAAwaitNetworkResponse<EndpointType.ResponseType>(urlResponse: response, with: data)

                    completion(.success(networkResponse))
                } catch {
                    print(error)
                    completion(.FAAwaitilure(.decodingError))
                }
            } else {
                /// - TODO: Chechk if response allways can be converted to HTTPURLResponse
                completion(.FAAwaitilure(.serviceError))
            }
        }
        return task
    }
}
