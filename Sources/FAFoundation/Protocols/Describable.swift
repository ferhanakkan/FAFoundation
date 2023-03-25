//
//  Describable.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

/// Describable protocol, Adds a typeName to describe self.
public protocol Describable {
    var typeName: String { get }
    static var typeName: String { get }
}

/// Provides an automatic implementation of protocol.
public extension Describable {
    var typeName: String {
        String(describing: self)
    }

    static var typeName: String {
        String(describing: self)
    }
}

/// Extension of Describable. Adds Describable to NSObject derived classes.
public extension Describable where Self: NSObjectProtocol {
    var typeName: String {
        let selfType = type(of: self)
        return String(describing: selfType)
    }
}
