//
//  FALocationStatus.swift
//  
//
//  Created by Ferhan Akkan on 11.09.2022.
//

import CoreLocation
import Foundation

public enum FALocationStatus {
    case avaiable
    case denied
    case notDetermined

    init(status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self = .avaiable
        case .denied, .restricted:
            self = .denied
        case .notDetermined:
            self = .notDetermined
        @unknown default:
            fatalError("Unexpected FALocationStatus Initialization",  file: #file, line: #line)
        }
    }
}
