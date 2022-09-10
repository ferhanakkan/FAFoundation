//
//  FAMultipartParameter.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public struct FAMultipartParameter: FAMultipartEncodable {
    public var name: String
    public var value: String

    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
