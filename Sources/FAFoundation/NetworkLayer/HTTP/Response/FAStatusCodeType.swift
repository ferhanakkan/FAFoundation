//
//  FAStatusCodeType.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public struct HTTPStatus {
    public let statusType: FAStatusCodeType
    public let statusCode: Int

    public init(httpUrlResponse: HTTPURLResponse) {
        self.statusType = .init(response: httpUrlResponse)
        self.statusCode = httpUrlResponse.statusCode
    }

    public init(statucCode: Int) {
        self.statusCode = statucCode
        self.statusType = .init(statusCode: statucCode)
    }

    public enum FAStatusCodeType {
        case success
        case badRequest
        case authenticationError
        case clientError
        case serverError
        case unRecognizedError

        init(response: HTTPURLResponse) {
            self.init(statusCode: response.statusCode)
        }

        init(statusCode: Int) {
            switch statusCode {
            case 200...299:
                self = .success
            case 400:
                self = .badRequest
            case 401:
                self = .authenticationError
            case 402...499:
                self = .clientError
            case 500...600:
                self = .serverError
            default:
                self = .unRecognizedError
            }
        }
    }
}
