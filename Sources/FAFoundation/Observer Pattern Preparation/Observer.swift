//
//  Observer.swift
//  
//
//  Created by Ferhan Akkan on 11.09.2022.
//

import Foundation

// MARK: - Observer
public final class Observer<T> {
    // MARK: Typealis
    public typealias ObserverBlock = (T) -> Void

    // MARK: Properties
    public let block: ObserverBlock
    public let queue: DispatchQueue

    public weak var observer: AnyObject?

    // MARK: Init
    init(observer: AnyObject, queue: DispatchQueue, block: @escaping ObserverBlock) {
        self.observer = observer
        self.queue = queue
        self.block = block
    }

    deinit {
        print("Deinit - Observer: \(self)")
        observer = nil
    }
}

