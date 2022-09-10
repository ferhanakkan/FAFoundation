//
//  URLParameterEncoding.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

enum FAAwaitEncodingError: Error {
    case missingURL
    case encodingFAAwaitiled
}

public struct FAAwaitURLParameterEncoder: ParameterEncoder {
    public func encode(urlRequest: inout URLRequest, with parameters: FAAwaitParameters) throws {
        guard let url = urlRequest.url else { throw FAAwaitEncodingError.missingURL  }

        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: FAAwaitlse), !parameters.isEmpty {
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
