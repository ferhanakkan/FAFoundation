//
//  Sequence+Extensions.swift
//  
//
//  Created by Ferhan Akkan on 11.09.2022.
//

import Foundation

extension Sequence where Iterator.Element: Equatable {
    public func removeDuplicates() -> [Iterator.Element] {
        return reduce([], { collection, element in collection.contains(element) ? collection : collection + [element] })
    }
}
