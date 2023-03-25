//
//  UserDefaultsManager.swift
//  FAFoundation_Example
//
//  Created by Ferhan Akkan on 13.09.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import FAFoundation

final class UserDefaultsManager {
    enum UserDefaultsKey: String {
        case primitiveExample
        case encodableExample
    }

    @FAUserDefaults(key: UserDefaultsKey.primitiveExample.rawValue)
    var primitiveExample: String?
    
    @FAUserDefaultsCodableValue(key: UserDefaultsKey.encodableExample.rawValue)
    var encodableExample: Bool?
}
