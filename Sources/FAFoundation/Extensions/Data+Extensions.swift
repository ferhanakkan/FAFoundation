//
//  Data+Extensions.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public extension Data {
    /**
     It parses  `Data` object to a JSON object.

     - Returns: `Result` objec.
     */
    func parse() throws -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? [String: Any]
        } catch let error {
            throw error
        }
    }

    /// Converts Data into value of type T
    ///
    /// - Returns: Value of Data in type T
    ///
    func to<T>(type: T.Type) -> T {
        self.withUnsafeBytes { $0.load(as: T.self) }
    }
}
