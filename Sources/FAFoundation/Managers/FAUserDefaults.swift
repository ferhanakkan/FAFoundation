//
//  FAUserDefaults.swift
//  
//
//  Created by Ferhan Akkan on 11.09.2022.
//

import Foundation

@propertyWrapper
struct FAUserDefaults<Value> {
    let key: String

    private let userDefaults = UserDefaults(suiteName: "faFoundation")

    var wrappedValue: Value? {
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
}

@propertyWrapper
struct FAUserDefaultsCodableValue<Value: Codable> {
    let key: String

    private let userDefaults = UserDefaults(suiteName: "faFoundation")

    var wrappedValue: Value? {
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
}

final class FAUserDefaultsManager {
    enum UserDefaultsKey: String {
        case primitiveExample
        case encodableExample
    }

    @FAUserDefaults(key: UserDefaultsKey.primitiveExample.rawValue)
    var primitiveExample: Bool?
    
    @FAUserDefaultsCodableValue(key: UserDefaultsKey.encodableExample.rawValue)
    var encodableExample: Bool?
}

//Example Usage
//final class TestUserDefaults {
//    
//    init() {
//        FAUserDefaultsManager().encodableExample = false
//        let result = FAUserDefaultsManager().encodableExample
//    }
//}
