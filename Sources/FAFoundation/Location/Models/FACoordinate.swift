//
//  FACoordinate.swift
//  
//
//  Created by Ferhan Akkan on 11.09.2022.
//

import CoreLocation

public struct FACoordinate {
    public let lat: Double
    public let lon: Double
}

public extension FACoordinate {
    init(with coordinate: CLLocationCoordinate2D) {
        self.lat = coordinate.latitude
        self.lon = coordinate.longitude
    }
}
