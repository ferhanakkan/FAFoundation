//
//  Dictonary+Extensions.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

/// Extension of Dictionary. Adds Json Conversion methods.
public extension Dictionary where Key == String, Value == Any {
    /**
        Converts Dictionary into JSON String and returns.

        - Returns: JSON representation of Dictionary as String or nil.
     */
    func asJSONString() -> String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self) else { return nil }
        guard let jsonRawContent = String(data: jsonData, encoding: .utf8) else { return nil }

        let jsonContent = jsonRawContent.replacingOccurrences(of: "\r\n", with: "")
        let content = jsonContent.replacingOccurrences(of: "\\", with: "")
        return content
    }
    /// Prints JSON Representation of Dictionary.
    func printAsJSON() {
        let jsonContent = self.asJSONString() ?? ""
        print(jsonContent)
    }
}
