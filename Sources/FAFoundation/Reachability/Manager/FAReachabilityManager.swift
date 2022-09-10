//
//  FAReachabilityManager.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Network

public protocol FAReachabilityManagerProtocol {
    func checkReachability(completion: @escaping (FAReachability) -> Void)
    func stopReachability()
    func isWiFiEnabled() -> Bool
}

final class FAReachabilityManager {
    // MARK: - Enums
    private enum Constants {
        static let awdl = "awdl0"
    }

    // MARK: - Properties
    private let monitor = NWPathMonitor()

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
    func checkReachability(completion: @escaping (FAReachability) -> Void) {
        monitor.start(queue: .global(qos: .background))
        var status: FAReachabilityStatus {
            switch monitor.currentPath.status {
            case .satisfied:
                return .satisfied
            default:
                return .requiresConnection
            }
        }

        guard let interface = NWInterface.InterfaceType.allCases.first(where: { monitor.currentPath.usesInterfaceType($0) }) else {
            completion(.init(type: .noConnection, status: .requiresConnection))
            stopReachability()
            return
        }
 
        var type: FAReachabilityType {
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

        completion(.init(type: type, status: status))
        stopReachability()
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

extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = NWInterface.InterfaceType.allCases
}
