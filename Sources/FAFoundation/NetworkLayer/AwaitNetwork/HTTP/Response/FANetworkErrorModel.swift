//
//  FAAwaitNetworkErrorModel.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public enum FAAwaitNetworkError: String, Error {
    case serviceError
    case decodingError
    case timeOut
    case noInternetConnection
}
