//
//  Completions.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public typealias VoidCompletion = (() -> ())
public typealias ValueCompletion<T> = ((T) -> Void)
public typealias StringCompletion = ((String) -> Void)

public typealias FAReachabilityCompletion = ((FAReachability) -> Void)
