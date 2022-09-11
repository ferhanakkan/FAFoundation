//
//  Observer.swift
//  
//
//  Created by Ferhan Akkan on 11.09.2022.
//

import Foundation

// MARK: - Observer
final class Observer<T> {
    // MARK: Typealis
    typealias ObserverBlock = (T) -> Void

    // MARK: Properties
    let block: ObserverBlock
    let queue: DispatchQueue

    weak var observer: AnyObject?

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

