//
//  AnyOptional.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

// AnyOptional protocol to make nil checks easier.
public protocol AnyOptional {
    var isNil: Bool { get }
    var isNotNil: Bool { get }
}

// Optional Extension to detect nil values.
extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }

    public var isNotNil: Bool { self != nil }
}
