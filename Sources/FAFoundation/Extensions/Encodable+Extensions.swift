//
//  Encodable+Extensions.swift
//  
//
//  Created by Ferhan Akkan on 11.09.2022.
//

import Foundation

extension Encodable {
    var asDictionary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else { return [:] }
        return dictionary
    }
}
