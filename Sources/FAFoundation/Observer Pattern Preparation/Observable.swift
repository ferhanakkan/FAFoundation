//
//  Observable.swift
//  
//
//  Created by Ferhan Akkan on 11.09.2022.
//

import Foundation

// MARK: - Observable
public final class Observable<T> {
    // MARK: Properties
    private var observers = [Observer<T>]()

    public var value: T {
        didSet {
            notifyObservers()
        }
    }

    // MARK: Init
    public init(_ value: T) {
        self.value = value
    }

    public func observe(
        on observer: AnyObject,
        queue: DispatchQueue = .main,
        observerBlock: @escaping Observer<T>.ObserverBlock
    ) {
        observers.append(
            Observer(
                observer: observer,
                queue: queue,
                block: observerBlock
            )
        )
    }

    public func observeAndFire(
        on observer: AnyObject,
        queue: DispatchQueue = .main,
        observerBlock: @escaping Observer<T>.ObserverBlock
    ) {
        observe(on: observer, queue: queue, observerBlock: observerBlock)
        observerBlock(value)
    }

    public func remove(observer: AnyObject) {
        observers = observers.filter({ $0.observer !== observer })
    }

    public func removeAllObservers() {
        observers = []
    }

    private func notifyObservers() {
        observers.forEach { observer in
            observer.queue.async {
                observer.block(self.value)
            }
        }
    }

    deinit {
        print("Deinit - Observable: \(self)")
        observers.removeAll()
    }
}

