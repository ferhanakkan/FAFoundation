//
//  LocationManager.swift
//  
//
//  Created by Ferhan Akkan on 11.09.2022.
//

import Foundation

public protocol LocationManagerOutputProtocol: AnyObject {
    func locationManager(_ manager: LocationManagerProtocol, didUpdateLocation location: FACoordinate, didUpdateAccuracy accuracy: FALocationAccuracy)
    func locationManager(_ manager: LocationManagerProtocol, didChangeAuthorizationStatus status: FALocationStatus)
    func locationManager(_ manager: LocationManagerProtocol, didDeniedAuthorizationStatus status: FALocationStatus)
}

public extension LocationManagerOutputProtocol {
    func locationManager(_ manager: LocationManagerProtocol, didUpdateLocation location: FACoordinate) {}
    func locationManager(_ manager: LocationManagerProtocol, didChangeAuthorizationStatus status: FALocationStatus) {}
    func locationManager(_ manager: LocationManagerProtocol, didDeniedAuthorizationStatus status: FALocationStatus) {}
}

public protocol LocationManagerProtocol {
    var delegate: LocationManagerOutputProtocol? { get set }
    var isUpdatingLocation: Bool { get }
    var isLocationServicesEnable: Bool { get }
    var lastLocation: FACoordinate? { get }
    var altitude: Double { get }
    var speed: Double { get }
    var allowsBackgroundLocationUpdates: Bool { get }
    var shouldCheckAuthorizationStatus:  Bool { get }
    func getDistanceToLastKnowLocation(with location: FACoordinate) -> Double?
    func stopUpdatingLocation()
    func startUpdatingLocation()
    func setBackgroundUpdate(isEnable: Bool)
    func getAuthorizationStatus() -> FALocationStatus
    func setBestDesiredAccuracy()
    func requestAuthorization()
}

public final class LocationManager: LocationManagerProtocol {
    
    private var locationHandler: LocationHandlerProtocol = LocationHandler()
    private var startUpdatingWhenPermissionAvaliable: Bool
    
    public weak var delegate: LocationManagerOutputProtocol?
    public var isUpdatingLocation: Bool = false
    
    /// Should add " Privacy - Location When In Use Usage Description " and  "Privacy - Location Always and When In Use Usage Description" to be enanble use this service. Also for background locations you have to add backgorund Modes Capability Location updates check.
    public init(startUpdatingWhenPermissionAvaliable: Bool = false) {
        self.startUpdatingWhenPermissionAvaliable = startUpdatingWhenPermissionAvaliable
        self.locationHandler.delegate = self
    }
}

public extension LocationManager  {
    
    var isLocationServicesEnable: Bool {
        locationHandler.isLocationServicesEnable
    }
    
    var lastLocation: FACoordinate? {
        locationHandler.lastLocation
    }
    
    var altitude: Double {
        locationHandler.altitude
    }
    
    var shouldCheckAuthorizationStatus: Bool {
        locationHandler.getAuthorizationStatus() != .avaiable
    }
    
    var speed: Double {
        locationHandler.speed
    }
    
    var allowsBackgroundLocationUpdates: Bool {
        locationHandler.allowsBackgroundLocationUpdates
    }
    
    func getDistanceToLastKnowLocation(with location: FACoordinate) -> Double? {
        locationHandler.getDistanceToLastKnowLocation(with: location)
    }
    
    func stopUpdatingLocation() {
        locationHandler.stopUpdatingLocation()
        isUpdatingLocation = false
    }
    
    func startUpdatingLocation() {
        guard getAuthorizationStatus() == .avaiable else {
            delegate?.locationManager(self, didDeniedAuthorizationStatus: getAuthorizationStatus())
            return
        }
        locationHandler.startUpdatingLocation()
        isUpdatingLocation = true
    }
    
    func setBackgroundUpdate(isEnable: Bool) {
        locationHandler.setBackgroundUpdate(isEnable: isEnable)
    }
    
    func getAuthorizationStatus() -> FALocationStatus {
        locationHandler.getAuthorizationStatus()
    }
    
    func setBestDesiredAccuracy() {
        locationHandler.setBestDesiredAccuracy()
    }
    
    func requestAuthorization() {
        guard getAuthorizationStatus() != .denied else {
            delegate?.locationManager(self, didDeniedAuthorizationStatus: .denied)
            return
        }
        locationHandler.requestAuthorization()
    }
}

extension LocationManager: LocationHandlerOutputProtocol {
    public func locationHandler(_ handler: LocationHandlerProtocol, didUpdateLocation location: FACoordinate, didUpdateAccuracy currentAccuracy: FALocationAccuracy) {
        delegate?.locationManager(self, didUpdateLocation: location, didUpdateAccuracy: currentAccuracy)
    }
    
    public func locationHandler(_ handler: LocationHandlerProtocol, didChangeAuthorizationStatus status: FALocationStatus) {
        delegate?.locationManager(self, didChangeAuthorizationStatus: status)
        if status == .avaiable && startUpdatingWhenPermissionAvaliable { startUpdatingLocation() }
    }
}
