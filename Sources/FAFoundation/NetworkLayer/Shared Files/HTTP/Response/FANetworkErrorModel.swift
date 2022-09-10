//
//  FANetworkErrorModel.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public enum FANetworkError: String, Error {
    case serviceError
    case decodingError
    case timeOut
    case noInternetConnection
}
