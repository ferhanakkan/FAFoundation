//
//  FAReachabilityManager.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Network

public protocol FAReachabilityManagerProtocol {
    var isReachable: Bool { get }
    func listenReachability(completion: @escaping FAReachabilityCompletion)
    func checkReachability(completion: @escaping FAReachabilityCompletion)
    func stopReachability()
    func isWiFiEnabled() -> Bool
}

final class FAReachabilityManager {
    // MARK: - Enums
    private enum Constants {
        static let awdl = "awdl0"
    }

    // MARK: - Properties
    var isReachable: Bool {
        let monitor = NWPathMonitor()
        monitor.start(queue: .main)
        return monitor.currentPath.status == .satisfied
    }
    
    private let monitor = NWPathMonitor()
    private var status: FAReachabilityStatus {
        switch monitor.currentPath.status {
        case .satisfied:
            return .satisfied
        default:
            return .requiresConnection
        }
    }

    // MARK: - Initialization
    init() {
        monitor.start(queue: .global(qos: .background))
    }

    // MARK: - Deinitialization
    deinit {
        stopReachability()
    }
}

// MARK: - FAReachabilityManagerProtocol
extension FAReachabilityManager: FAReachabilityManagerProtocol {
    func listenReachability(completion: @escaping FAReachabilityCompletion) {
        monitor.pathUpdateHandler = { [weak self] path in
            guard
                let self = self,
                let interface = NWInterface.InterfaceType.allCases.first(where: { self.monitor.currentPath.usesInterfaceType($0)})
            else {
                completion(.init(type: .noConnection, status: .requiresConnection))
                return
            }
            completion(.init(type: self.getInterfaceType(with: interface), status: self.status))
        }
        monitor.start(queue: .global(qos: .background))
    }
    
    func checkReachability(completion: @escaping FAReachabilityCompletion) {
        let monitor = NWPathMonitor()
        monitor.start(queue: .global(qos: .background))
        defer {
            monitor.cancel()
        }

        guard let interface = NWInterface.InterfaceType.allCases.first(where: { monitor.currentPath.usesInterfaceType($0) }) else {
            completion(.init(type: .noConnection, status: .requiresConnection))
            return
        }
        completion(.init(type: getInterfaceType(with: interface), status: status))
    }

    func stopReachability() {
        monitor.cancel()
    }

    func isWiFiEnabled() -> Bool {
        var addresses: [String] = []
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == .zero,
              let firstAddress = ifaddr else { return false }
        for pointer in sequence(first: firstAddress, next: { $0.pointee.ifa_next }) {
            addresses.append(String(cString: pointer.pointee.ifa_name))
        }

        var counts: [String: Int] = [:]
        for item in addresses {
            counts[item] = (counts[item].orZero) + 1
        }
        freeifaddrs(ifaddr)
        guard let count = counts[Constants.awdl] else { return false }
        return count > 1
    }
}

private extension FAReachabilityManager {
    func getInterfaceType(with interface: NWInterface.InterfaceType) -> FAReachabilityType {
        switch interface {
        case .wifi:
            return .wifi
        case .cellular:
            return .cellular
        case .wiredEthernet:
            return .wiredEthernet
        default:
            return .loopback
        }
    }
}

extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = NWInterface.InterfaceType.allCases
}
