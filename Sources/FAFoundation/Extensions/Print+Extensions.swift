//
//  Print+Extensions.swift
//  
//
//  Created by Ferhan Akkan on 11.09.2022.
//

import Foundation

public func print(_ object: Any...) {
    #if DEBUG
    for item in object {
        Swift.print(item)
    }
    #endif
}

public func print(_ object: Any) {
    #if DEBUG
    Swift.print(object)
    #endif
}
