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

    var httpMethod: FAHTTPMethod { get }

    var task: FAHTTPTask { get }

    var headers: FAHTTPHeaders? { get }
}

extension FAAwaitEndpoint {
    var headers: FAHTTPHeaders? {
        nil
    }

    var allHeaders: FAHTTPHeaders? {
        var allHeaders: [FAHTTPHeader] = []

        allHeaders += headers?.headers ?? []
        allHeaders += baseHeaders?.headers ?? []

        return .init(headers: allHeaders)
    }

    public var timeout: TimeInterval {
        30
    }
}

public protocol FAAwaitAPI {
    var baseHeaders: FAHTTPHeaders? { get }
    var baseURL: URL { get }
    var timeout: TimeInterval { get }
}

