//
//  FAComplectionNetwork.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

public struct FACompletionNetwork {
    public static var shared: FANetworkManagerProtocol {
        FANetworkManager.shared
    }
    
    private init() {}
}
