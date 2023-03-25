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

    private var userDefaults: UserDefaults {
        return UserDefaults(suiteName: Constants.FAUserDefaults.suiteName)!
    }

    public var wrappedValue: Value? {
        get {
            userDefaults.value(forKey: key) as? Value
        }

        set {
            if let value = newValue {
                userDefaults.setValue(value, forKey: key)
            } else {
                userDefaults.removeObject(forKey: key)
            }
        }
    }

    public init(key: String) {
        self.key = key
    }
}
