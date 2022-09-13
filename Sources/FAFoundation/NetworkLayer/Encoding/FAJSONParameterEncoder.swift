//
//  FAJSONParameterEncoder.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public struct FAJSONParameterEncoder: ParameterEncoder {
    public func encode(urlRequest: inout URLRequest, with parameters: FAParameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw FAEncodingError.encodingFailed
        }
    }
}
