//
//  DispatchQueue+Extensions.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Foundation

public extension DispatchQueue {
    // This method will dispatch the `block` to self.
    // If `self` is the main queue, and current thread is main thread, the block
    // will be invoked immediately instead of being dispatched.
    func safeAsync(_ block: @escaping ()->()) {
        if self === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            async { block() }
        }
    }

    func safeAsync(execute: @escaping @autoclosure () -> Void?) {
        safeAsync {
            execute()
        }
    }
    
    /// A Boolean value indicating whether the current dispatch queue is the main queue.
     static var isMainQueue: Bool {
         enum Static {
             static var key: DispatchSpecificKey<Void> = {
                 let key = DispatchSpecificKey<Void>()
                 DispatchQueue.main.setSpecific(key: key, value: ())
                 return key
             }()
         }
         return DispatchQueue.getSpecific(key: Static.key) != nil
     }
    
    /// Returns a Boolean value indicating whether the current dispatch queue is the specified queue.
    ///
    /// - Parameter queue: The queue to compare against.
    /// - Returns: `true` if the current queue is the specified queue, otherwise `false`.
    static func isCurrent(_ queue: DispatchQueue) -> Bool {
        let key = DispatchSpecificKey<Void>()

        queue.setSpecific(key: key, value: ())
        defer { queue.setSpecific(key: key, value: nil) }

        return DispatchQueue.getSpecific(key: key) != nil
    }
    
    /// Runs passed closure asynchronous after certain time interval.
    ///
    /// - Parameters:
    ///   - delay: The time interval after which the closure will run.
    ///   - qos: Quality of service at which the work item should be executed.
    ///   - flags: Flags that control the execution environment of the work item.
    ///   - work: The closure to run after certain time interval.
    func asyncAfter(delay: Double,
                    qos: DispatchQoS = .unspecified,
                    flags: DispatchWorkItemFlags = [],
                    execute work: @escaping () -> Void) {
        asyncAfter(deadline: .now() + delay, qos: qos, flags: flags, execute: work)
    }
    
    func debounce(delay: Double, action: @escaping VoidCompletion) -> VoidCompletion {
        // http://stackoverflow.com/questions/27116684/how-can-i-debounce-a-method-call
        // https://www.youtube.com/watch?v=uSbt2L223rw
        var lastFireTime = DispatchTime.now()
        let deadline = { lastFireTime + delay }
        return {
            self.asyncAfter(deadline: deadline()) {
                let now = DispatchTime.now()
                if now >= deadline() {
                    lastFireTime = now
                    action()
                }
            }
        }
    }
}

public extension DispatchQueue {
    /// Shows current thread and queue
    static func log(action: String) {
        print("""
        \(action)
        🤓 \(String(validatingUTF8: __dispatch_queue_get_label(nil))!)
        🧐 \(Thread.current)
        """)
    }
    
}
