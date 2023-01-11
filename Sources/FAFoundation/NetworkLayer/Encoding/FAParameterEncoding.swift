//
//  FAParameterEncoding.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public typealias FAParameters = [String: Any]

public protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: FAParameters) throws
}

public enum FAParameterEncoding {
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding
    case bodyAsStringEncoding(Data)

    public func encode(urlRequest: inout URLRequest,
                       bodyParameters: FAParameters?,
                       urlParameters: FAParameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                try FAURLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)

            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try FAJSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)

            case .urlAndJsonEncoding:
                guard let bodyParameters = bodyParameters,
                      let urlParameters = urlParameters else { return }
                try FAURLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                try FAJSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
            case .bodyAsStringEncoding(let data):
                urlRequest.httpBody = data
            }
        } catch {
            throw error
        }
    }
}
