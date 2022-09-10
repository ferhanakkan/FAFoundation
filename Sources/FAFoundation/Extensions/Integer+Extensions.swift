//
//  Integer+Extensions.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public extension Int {
    
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
        Returns Double of self.

        - Returns: Double with value of self.
     */
    var asDouble: Double  {
        Double(self)
    }
}
