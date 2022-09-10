//
//  FAHTTPHeader.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public struct FAHTTPHeaders {
    public let headers: [FAHTTPHeader]

    public init(headers: [FAHTTPHeader]) {
        self.headers = headers
    }

    public init(headers: [FAHTTPHeader?]) {
        self.headers = headers.compactMap({ $0 })
    }

    var asDictionary: [String: String] {
        var dictionary: [String: String] = [:]
        for header in headers {
            dictionary[header.key] = header.value
        }

        return dictionary
    }
}

public struct FAHTTPHeader {
    public let key: String
    public let value: String

    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }

    public init?(key: String?, value: String?) {
        guard let key = key, let value = value else { return nil }
        self.key = key
        self.value = value
    }
}
