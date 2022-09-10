//
//  URLParameterEncoding.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

enum FAEncodingError: Error {
    case missingURL
    case encodingFailed
}

public struct FAURLParameterEncoder: ParameterEncoder {
    public func encode(urlRequest: inout URLRequest, with parameters: FAParameters) throws {
        guard let url = urlRequest.url else { throw FAEncodingError.missingURL  }

        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()

            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
