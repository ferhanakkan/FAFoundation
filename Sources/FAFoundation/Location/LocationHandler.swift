//
//  LocationHandler.swift
//  
//
//  Created by Ferhan Akkan on 11.09.2022.
//

import CoreLocation
import Foundation

public protocol LocationHandlerOutputProtocol: AnyObject {
    func locationHandler(_ handler: LocationHandlerProtocol, didUpdateLocation location: FACoordinate)
    func locationHandler(_ handler: LocationHandlerProtocol, didChangeAuthorizationStatus status: FALocationStatus)
}

public protocol LocationHandlerProtocol {
    var delegate: LocationHandlerOutputProtocol? { get set }
    var isLocationServicesEnable: Bool { get }
    var lastLocation: FACoordinate? { get }
    var altitude: Double { get }
    var speed: Double { get }
    var allowsBackgroundLocationUpdates: Bool { get }
    func getDistanceToLastKnowLocation(with location: FACoordinate) -> Double?
    func stopUpdatingLocation()
    func startUpdatingLocation()
    func setBackgroundUpdate(isEnable: Bool)
    func getAuthorizationStatus() -> FALocationStatus
    func setBestDesiredAccuracy()
    func requestAuthorization()
}

final class LocationHandler: NSObject {
    
    weak var delegate: LocationHandlerOutputProtocol?
    
    var isLocationServicesEnable: Bool {
        CLLocationManager.locationServicesEnabled()
    }
    
    var lastLocation: FACoordinate? {
        guard let coordinate = lastKnownLocation?.coordinate else {
            return nil
        }
        return .init(with: coordinate)
    }
    
    var altitude: Double {
        lastKnownLocation?.altitude ?? .zero
    }
    
    var speed: Double {
        let speed = lastKnownLocation?.speed ?? .zero
        return (speed > .zero ? speed : .zero)
    }
    
    var allowsBackgroundLocationUpdates: Bool {
        coreLocationManager.allowsBackgroundLocationUpdates
    }
    
    private var lastKnownLocation: CLLocation?
    private var isFirstStatusChange: Bool = true
    private let coreLocationManager: CLLocationManager
    
    init(coreLocationManager: CLLocationManager = .init()) {
        self.coreLocationManager = coreLocationManager
        
        super.init()
        
        self.coreLocationManager.delegate = self
    }
    
}

extension LocationHandler: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard !isFirstStatusChange else {
            isFirstStatusChange = false
            return
        }
        delegate?.locationHandler(self, didChangeAuthorizationStatus: .init(status: coreLocationManager.authorizationStatus))
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        lastKnownLocation = locations.last
        guard let lastLocation else {
            return
        }
        delegate?.locationHandler(self, didUpdateLocation: lastLocation)
    }
}

extension LocationHandler: LocationHandlerProtocol {
    
    func getDistanceToLastKnowLocation(with location: FACoordinate) -> Double? {
        guard let lastKnownLocation else {
            return nil
        }
        return lastKnownLocation.distance(from: .init(latitude: location.lat, longitude: location.lon))
    }
    
    func stopUpdatingLocation() {
        coreLocationManager.stopUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        coreLocationManager.startUpdatingLocation()
    }
    
    func setBackgroundUpdate(isEnable: Bool) {
        coreLocationManager.allowsBackgroundLocationUpdates = isEnable
    }
    
    func getAuthorizationStatus() -> FALocationStatus {
        return FALocationStatus(status: coreLocationManager.authorizationStatus)
    }
    
    func setBestDesiredAccuracy() {
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    func requestAuthorization() {
        coreLocationManager.requestAlwaysAuthorization()
    }
}
