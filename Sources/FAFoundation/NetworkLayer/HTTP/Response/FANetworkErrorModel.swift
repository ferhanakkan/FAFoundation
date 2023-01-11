//
//  FANetworkErrorModel.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public enum FANetworkError: Error {
    case serviceError
    case decodingError(Data)
    case timeOut
    case noInternetConnection

    var userFriendlyDescription: String {
        return "TODO"
    }
}
