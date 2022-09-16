//
//  FAReachabilityManager.swift
//  
//
//  Created by Ferhan Akkan on 10.09.2022.
//

import Network

public protocol FAReachabilityManagerProtocol {
    var isReachable: Bool { get }
    var connectionType: FAReachabilityType { get }
    func listenReachabilityChanges(_ queue: DispatchQueue, completion: @escaping FAReachabilityCompletion)
//    func isWiFiEnabled() -> Bool
}

public final class FAReachabilityManager {
    // MARK: - Enums
    private enum Constants {
        static let awdl = "awdl0"
    }

    // MARK: - Properties
    public var isReachable: Bool {
        return monitor.currentPath.status == .satisfied
    }
    
    public var connectionType: FAReachabilityType {
        guard let interface = NWInterface.InterfaceType.allCases.first(where: { [weak self] in
            guard let self = self else { return false }
            return self.monitor.currentPath.usesInterfaceType($0)}) else {
            return .noConnection
        }
        return getInterfaceType(with: interface)
    }
    
    private var status: FAReachabilityStatus {
        switch monitor.currentPath.status {
        case .satisfied:
            return .satisfied
        default:
            return .requiresConnection
        }
    }
    
    private let monitor: NWPathMonitor

    // MARK: - Initialization
    public init(preferedQueue: DispatchQueue = .main) {
        monitor = .init()
        monitor.start(queue: preferedQueue)
    }

    // MARK: - Deinitialization
    deinit {
        monitor.cancel()
    }
}

// MARK: - FAReachabilityManagerProtocol
extension FAReachabilityManager: FAReachabilityManagerProtocol {
    public func listenReachabilityChanges(_ queue: DispatchQueue, completion: @escaping FAReachabilityCompletion) {
        monitor.pathUpdateHandler = { [weak self] path in
            guard
                let self = self,
                let interface = NWInterface.InterfaceType.allCases.first(where: { [weak self] in
                    guard let self = self else { return false }
                    return self.monitor.currentPath.usesInterfaceType($0)})
            else {
                completion(.init(type: .noConnection, status: .requiresConnection))
                return
            }
            completion(.init(type: self.getInterfaceType(with: interface), status: self.status))
        }
    }

    // TODO: Should refactor always returns ture
//    public func isWiFiEnabled() -> Bool {
//        var addresses: [String] = []
//        var ifaddr: UnsafeMutablePointer<ifaddrs>?
//        guard getifaddrs(&ifaddr) == .zero,
//              let firstAddress = ifaddr else { return false }
//        for pointer in sequence(first: firstAddress, next: { $0.pointee.ifa_next }) {
//            addresses.append(String(cString: pointer.pointee.ifa_name))
//        }
//
//        var counts: [String: Int] = [:]
//        for item in addresses {
//            counts[item] = (counts[item].orZero) + 1
//        }
//        freeifaddrs(ifaddr)
//        guard let count = counts[Constants.awdl] else { return false }
//        return count > 1
//    }
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
    public static var allCases: [NWInterface.InterfaceType] = [.cellular, .loopback, .other, .wifi, .wiredEthernet]
}
