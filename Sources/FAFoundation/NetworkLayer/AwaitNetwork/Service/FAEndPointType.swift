//
//  FAAwaitEndPointType.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public protocol FAAwaitEndpoint: FAAwaitAPI {
    associatedtype ResponseType: Decodable

    var path: String { get }

    var httpMethod: FAAwaitHTTPMethod { get }

    var task: FAAwaitHTTPTask { get }

    var headers: FAAwaitHTTPHeaders? { get }
}

extension FAAwaitEndpoint {
    var headers: FAAwaitHTTPHeaders? {
        nil
    }

    var allHeaders: FAAwaitHTTPHeaders? {
        var allHeaders: [FAAwaitHTTPHeader] = []

        allHeaders += headers?.headers ?? []
        allHeaders += baseHeaders?.headers ?? []

        return .init(headers: allHeaders)
    }

    public var timeout: TimeInterval {
        30
    }
}

public protocol FAAwaitAPI {
    var baseHeaders: FAAwaitHTTPHeaders? { get }
    var baseURL: URL { get }
    var timeout: TimeInterval { get }
}

