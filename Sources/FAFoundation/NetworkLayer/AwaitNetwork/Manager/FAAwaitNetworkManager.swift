////
////  FAAwaitNetworkManager.swift
////  
////
////  Created by Ferhan Akkan on 10.09.2022.
////
//
//import UIKit
//
//public typealias FAAwaitNetworkCompletion<Response: Decodable> = (Result<FANetworkResponse<Response>, FANetworkError>, URLSessionTask?)
//
//typealias FAAwaitServiceCompletion<Response: Decodable> = (Result<Response, FANetworkError>)
//
//typealias FAAwaitServiceCompletionStatusCode<Response: Decodable> = (Result<(response: Response, status: HTTPStatus), FANetworkError>)
//
//public protocol FAAwaitNetworkManagerProtocol {
//    static var shared: FAAwaitNetworkManagerProtocol { get }
//    var reachability: FAReachabilityManagerProtocol { get }
//    
//    func genericFetch<EndpointType: FAEndpoint>(queue: DispatchQueue,
//                                                _ endpoint: EndpointType) async -> FAAwaitNetworkCompletion<EndpointType.ResponseType>
//}
//
//public extension FAAwaitNetworkManagerProtocol {
//    
//    func genericFetch<EndpointType: FAEndpoint>(queue: DispatchQueue,
//                                                _ endpoint: EndpointType) async -> FAAwaitNetworkCompletion<EndpointType.ResponseType> {
//        await genericFetch(queue: .main, endpoint)
//    }
//
//    static var shared: FAAwaitNetworkManagerProtocol {
//        FAAwaitNetworkManager.shared
//    }
//
//    var reachability: FAReachabilityManagerProtocol {
//        FAAwaitNetworkManager.shared.reachability
//    }
//}
//
//struct FAAwaitNetworkManager: FAAwaitNetworkManagerProtocol {
//    static let shared: FAAwaitNetworkManager = .init()
//    public let reachability = FAReachabilityManager()
//
////    func genericFetch<EndpointType: FAEndpoint>(queue: DispatchQueue = .main,
////                                                _ endpoint: EndpointType,
////                                                completion: @escaping FAAwaitNetworkCompletion<EndpointType.ResponseType>) -> URLSessionTask? {
////        genericFetch(endpoint) { result in
////            queue.safeAsync {
////                completion(result)
////            }
////        }
////    }
//    
//    func genericFetch<EndpointType: FAEndpoint>(queue: DispatchQueue,
//                                                _ endpoint: EndpointType) async -> FAAwaitNetworkCompletion<EndpointType.ResponseType> {
//        await genericFetch(endpoint)
//    }
//
//    private func genericFetch<EndpointType: FAEndpoint>(_ endpoint: EndpointType) async -> FAAwaitNetworkCompletion<EndpointType.ResponseType> {
//        let task = FATRouter().request(endpoint, timeout: endpoint.timeout) { data, response, error in
//            guard error == nil, let data = data else {
////                completion(.failure(.serviceError))
//                return FAAwaitNetworkCompletion
//            }
//            if let response = response as? HTTPURLResponse {
//                do {
//                    let networkResponse = try FANetworkResponse<EndpointType.ResponseType>(urlResponse: response, with: data)
//
////                    completion(.success(networkResponse))
//                } catch {
//                    print(error)
////                    completion(.failure(.decodingError))
//                }
//            } else {
//                /// - TODO: Chech if response allways can be converted to HTTPURLResponse
////                completion(.failure(.serviceError))
//                return
//            }
//        }
//    }
//}
