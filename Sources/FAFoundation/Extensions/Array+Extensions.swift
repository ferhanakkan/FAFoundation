//
//  Array+Extensions.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

/// Extension of Array. Adds capability to drop first item or emptiness of Array.
public extension Array {
    /// Returns if array is Not Empty.
    var isNotEmpty: Bool {
        !isEmpty
    }
    /// Returns Array with dropping first item.
    var withoutFirstItem: Array {
        Array(dropFirst())
    }
}

/// Extension of Array. Adds capability to safe subscript Array with Element
public extension Array {
    /**
        Returns element for given index.

        - Parameter index: Index to retrieve Element.

        - Returns: Element matching index or nil.
     */
    subscript(safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}

/// Extension of Array. Adds Json Conversion to Array.
public extension Array {
    /// Returns JSON Representation of Array.
    var json: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}

/// Extension of Array. Moves an element to first.
public extension Array {
    /**
     Moves an element to the first index.

     - Parameters:
        - index: index of element to be moved to first index
     */
    mutating func moveToFirst(from index: Int) {
        guard index >= 0, index < count else { return }
        let element = self.remove(at: index)
        insert(element, at: 0)
    }
}

/// Extension of Array. Removes first element if exists.
public extension Array {
    /**
     Removes first element if exists.
     */
    @discardableResult
    mutating func removeFirstSafely() -> Self.Element? {
        if !isEmpty {
            return removeFirst()
        }

        return nil
    }
}

/// Extension of Array. Deep Copy for element of Array .
public extension Array where Element: NSCopying {
    func clone() -> Array {
        var copiedArray = [Element]()
        for element in self {
            copiedArray.append(element.copy() as! Element)
        }
        return copiedArray
    }
}
