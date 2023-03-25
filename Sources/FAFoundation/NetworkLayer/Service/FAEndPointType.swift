//
//  FAEndPointType.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public protocol FAEndpoint: FAAPI {

    associatedtype ResponseType: Decodable

    var path: String { get }

    var httpMethod: FAHTTPMethod { get }

    var task: FAHTTPTask { get }

    var headers: FAHTTPHeaders? { get }
}

public extension FAEndpoint {

    var headers: FAHTTPHeaders? {
        nil
    }

    var allHeaders: FAHTTPHeaders? {
        var allHeaders: [FAHTTPHeader] = []

        allHeaders += headers?.headers ?? []
        allHeaders += baseHeaders?.headers ?? []

        return .init(headers: allHeaders)
    }

    var timeout: TimeInterval {
        30
    }
}

public protocol FAAPI {

    var baseHeaders: FAHTTPHeaders? { get }
    var baseURL: URL { get }
    var timeout: TimeInterval { get }
}

