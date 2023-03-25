//
//  FAUserDefaultsCodableValue.swift
//  
//
//  Created by Ferhan Akkan on 7.01.2023.
//

import Foundation

@propertyWrapper
public struct FAUserDefaultsCodableValue<Value: Codable> {

    let key: String
    let defaultValue: Value

    private var userDefaults: UserDefaults {
        return UserDefaults(suiteName: Constants.FAUserDefaults.suiteName)!
    }

    public var wrappedValue: Value {
        get {
            guard let data = userDefaults.object(forKey: key) as? Data else {
                return defaultValue
            }

            let value = try? JSONDecoder().decode(Value.self, from: data)
            return value ?? defaultValue
        }

        set {
            let data = try? JSONEncoder().encode(newValue)
            userDefaults.set(data, forKey: key)
        }
    }

    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
