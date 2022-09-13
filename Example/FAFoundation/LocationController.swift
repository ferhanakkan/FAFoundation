//
//  LocationController.swift
//  FAFoundation_Example
//
//  Created by Ferhan Akkan on 13.09.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import FAFoundation
import UIKit

final class LocationController: BaseViewController {
    
    // MARK: Properties    
    private let label: UILabel = {
       let label = UILabel()
        label.text = "Location Doesnt Updating"
        label.numberOfLines = 5
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.borderColor = UIColor.blue.cgColor
        label.layer.borderWidth  = 2
       return label
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Start Location", for: .normal)
        button.addTarget(self, action: #selector(didTapStartLocation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints  = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Stop Location", for: .normal)
        button.addTarget(self, action: #selector(didTapStopLocation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints  = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private lazy var permissionButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Request Permission", for: .normal)
        button.addTarget(self, action: #selector(didTapRequestPermission), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints  = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private var locationManager: LocationManagerProtocol
    
    init(locationManager: LocationManagerProtocol = LocationManager()) {
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
        
        self.locationManager.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(permissionButton)
        stackView.addArrangedSubview(startButton)
        stackView.addArrangedSubview(stopButton)
        stackView.addArrangedSubview(UIView())
    }
}

// MARK:  LocationManagerOutputProtocol
extension LocationController: LocationManagerOutputProtocol {
    func locationManager(_ manager: LocationManagerProtocol, didUpdateLocation location: FACoordinate) {
        label.text = String(location.lon.asInt)
    }
    
    func locationManager(_ manager: LocationManagerProtocol, didChangeAuthorizationStatus status: FALocationStatus) {
        switch status {
        case .avaiable:
            manager.isUpdatingLocation ? nil : manager.startUpdatingLocation()
        default:
            presentPermissionAlert()
        }
    }
    
    func locationManager(_ manager: LocationManagerProtocol, didDeniedAuthorizationStatus status: FALocationStatus) {
        guard status == .denied else {
            return
        }
        presentPermissionAlert()
    }
}

// MARK:  Alert
private extension LocationController {
    func presentPermissionAlert() {
        let alert = UIAlertController(title: "Permission Issue", message: "Open Location Permission From Phone Settings", preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func presentPermissionAvaliableAlert() {
        let alert = UIAlertController(title: "Permission Avaliable", message: "Already Permission Avaliable", preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK:  Private Actions
private extension LocationController {
    @objc func didTapStartLocation() {
        locationManager.startUpdatingLocation()
    }
    
    @objc func didTapStopLocation() {
        locationManager.stopUpdatingLocation()
        label.text = "Location Doesn't Updating"
    }
    
    @objc func didTapRequestPermission() {
        guard locationManager.getAuthorizationStatus() != .avaiable else {
            presentPermissionAvaliableAlert()
            return
        }
        locationManager.requestAuthorization()
    }
}
