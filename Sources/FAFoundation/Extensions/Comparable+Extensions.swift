//
//  Comparable+Extensions.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public extension Comparable {
    /// Limits the comparable value in between the given closed range
    ///
    ///     let number = 0.5
    ///     print(number.clamped(to: 0...0.4))
    ///     // Prints "0.4"
    ///
    ///     let number = 0.3
    ///     print(number.clamped(to: 0...0.4))
    ///     // Prints "0.3"
    ///
    ///     let number = 2
    ///     print(number.clamped(to: 3...13))
    ///     // Prints "3"
    ///
    /// - Parameter limits: The limiting range
    ///
    /// - Returns: Arranged and cut down version of the comparable value

    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
