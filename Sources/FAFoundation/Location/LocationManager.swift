//
//  LocationManager.swift
//  
//
//  Created by Ferhan Akkan on 11.09.2022.
//

import Foundation

public protocol LocationManagerOutputProtocol: AnyObject {
    func locationManager(_ manager: LocationManagerProtocol, didUpdateLocation location: FACoordinate)
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
    func startLocationFlowWithAuthorization()
}

public final class LocationManager: LocationManagerProtocol {
    
    private var locationHandler: LocationHandlerProtocol
    public weak var delegate: LocationManagerOutputProtocol?
    
    /// Should add " Privacy - Location When In Use Usage Description " and  "Privacy - Location Always and When In Use Usage Description" to be enanble use this service. Also for background locations you have to add backgorund Modes Capability Location updates check.
    init(locationHandler: LocationHandlerProtocol = LocationHandler()) {
        self.locationHandler = locationHandler
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
    }
    
    func startUpdatingLocation() {
        locationHandler.startUpdatingLocation()
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
    
    func startLocationFlowWithAuthorization() {
       let status = locationHandler.getAuthorizationStatus()
        switch status {
        case .avaiable:
            locationHandler.startUpdatingLocation()
        case .denied:
            delegate?.locationManager(self, didDeniedAuthorizationStatus: status)
        case .notDetermined:
            locationHandler.requestAuthorization()
        }
    }
}

extension LocationManager: LocationHandlerOutputProtocol {
    public func locationHandler(_ handler: LocationHandlerProtocol, didUpdateLocation location: FACoordinate) {
        delegate?.locationManager(self, didUpdateLocation: location)
    }
    
    public func locationHandler(_ handler: LocationHandlerProtocol, didChangeAuthorizationStatus status: FALocationStatus) {
        delegate?.locationManager(self, didChangeAuthorizationStatus: status)
    }
}
