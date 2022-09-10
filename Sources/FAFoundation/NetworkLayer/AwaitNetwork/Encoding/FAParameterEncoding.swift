//
//  FAAwaitParameterEncoding.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public typealias FAAwaitParameters = [String: Any]

public protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: FAAwaitParameters) throws
}

public enum FAAwaitParameterEncoding {
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding

    public func encode(urlRequest: inout URLRequest,
                       bodyParameters: FAAwaitParameters?,
                       urlParameters: FAAwaitParameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                try FAAwaitURLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)

            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try FAAwaitJSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)

            case .urlAndJsonEncoding:
                guard let bodyParameters = bodyParameters,
                      let urlParameters = urlParameters else { return }
                try FAAwaitURLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                try FAAwaitJSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
            }
        } catch {
            throw error
        }
    }
}
