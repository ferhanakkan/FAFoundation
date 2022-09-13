//
//  FAUserDefaults.swift
//  
//
//  Created by Ferhan Akkan on 11.09.2022.
//

import Foundation

@propertyWrapper
public struct FAUserDefaults<Value> {
    let key: String

    private let userDefaults = UserDefaults(suiteName: "faFoundation")

    public var wrappedValue: Value? {
        get {
            userDefaults?.value(forKey: key) as? Value
        }

        set {
            if let value = newValue {
                userDefaults?.setValue(value, forKey: key)
            } else {
                userDefaults?.removeObject(forKey: key)
            }
        }
    }
    
    public init(key: String) {
        self.key = key
    }
}

@propertyWrapper
public struct FAUserDefaultsCodableValue<Value: Codable> {
    let key: String

    private let userDefaults = UserDefaults(suiteName: "faFoundation")

    public var wrappedValue: Value? {
        get {
            guard let data = userDefaults?.data(forKey: key) else {
                return nil
            }

            return try? JSONDecoder().decode(Value.self, from: data)
        }

        set {
            if let value = newValue {
                userDefaults?.set(value.asDictionary, forKey: key)
            } else {
                userDefaults?.removeObject(forKey: key)
            }
        }
    }
    
    public init(key: String) {
        self.key = key
    }
}
