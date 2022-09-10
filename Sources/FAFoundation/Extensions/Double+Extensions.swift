//
//  Double+Extensions.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

/// Extension of Double. Adds following capability; round double to decimal places.
public extension Double {
    /**
        Returns CGFloat of self.

        - Returns: CGFloat with value of self.
     */
    var asCGFloat: CGFloat {
        CGFloat(self)
    }
    
    /**
        Returns Float of self.

        - Returns: Float with value of self.
     */
    var asFloat: Float {
        Float(self)
    }
    
    /**
        Returns Int of self.

        - Returns: Int with value of self.
     */
    var asInt: Int {
        Int(self)
    }
    
    /// Rounds the double to decimal places value.
    /// - Parameter places: Decimal places to round.
    /// - Returns: Rounded value to given decimal places.
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

    /// Omits the zero at the end of double value and convert it to String
    /// - Parameter formatInfo: String format info
    /// - Returns: Zero omitted string value
    func zeroOmitted(formatInfo: String = "%.1f") -> String {
        truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: formatInfo, self)
    }
}
