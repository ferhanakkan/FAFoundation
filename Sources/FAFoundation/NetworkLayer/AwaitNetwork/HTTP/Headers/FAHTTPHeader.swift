//
//  FAAwaitHTTPHeader.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public struct FAAwaitHTTPHeaders {
    public let headers: [FAAwaitHTTPHeader]

    public init(headers: [FAAwaitHTTPHeader]) {
        self.headers = headers
    }

    public init(headers: [FAAwaitHTTPHeader?]) {
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

public struct FAAwaitHTTPHeader {
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
