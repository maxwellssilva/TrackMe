//
//  LocationManager.swift
//  TrackMe
//
//  Created by Maxwell Silva on 17/03/25.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(_ location: CLLocation)
    func didFailWithError(_ error: Error)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        delegate?.didUpdateLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        delegate?.didFailWithError(error)
    }
}
