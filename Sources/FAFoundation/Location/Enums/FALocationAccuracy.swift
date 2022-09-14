//
//  FALocationAccuracy.swift
//  
//
//  Created by Ferhan Akkan on 11.09.2022.
//

import CoreLocation
import Foundation

//    extern const CLLocationAccuracy kCLLocationAccuracyBestForNavigation; // (raw value: -2)
//    extern const CLLocationAccuracy kCLLocationAccuracyBest; // (raw value: -1)
//    extern const CLLocationAccuracy kCLLocationAccuracyNearestTenMeters; // (raw value: 10)
//    extern const CLLocationAccuracy kCLLocationAccuracyHundredMeters; // (raw value: 100)
//    extern const CLLocationAccuracy kCLLocationAccuracyKilometer; // (raw value: 1000)
//    extern const CLLocationAccuracy kCLLocationAccuracyThreeKilometers; // (raw value: 3000)
    
  public enum FALocationAccuracy {
        case bestForNavigation
        case best
        case nearestTenMeters
        case hundredMeters
        case kilometer
        case threeKilometers
        case bad
        
        init(with accuracy: CLLocationAccuracy) {
            switch accuracy {
            case let accuracy where  accuracy <= -2:
                self = .bestForNavigation
            case let accuracy where  accuracy <= -1:
                self = .best
            case let accuracy where  accuracy <= 10:
                self = .nearestTenMeters
            case let accuracy where  accuracy <= 100:
                self = .hundredMeters
            case let accuracy where  accuracy <= 1000:
                self = .kilometer
            case let accuracy where  accuracy <= 3000:
                self = .threeKilometers
            default:
                self = .bad
            }
        }
    }
