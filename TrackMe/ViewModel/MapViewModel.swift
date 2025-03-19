//
//  MapViewModel.swift
//  TrackMe
//
//  Created by Maxwell Silva on 17/03/25.
//

import Foundation
import CoreLocation

class MapViewModel: NSObject {

    private let locationManager = LocationManager()
    
    var onLocationUpdated: ((CLLocationCoordinate2D) -> Void)?
    var onError: ((String) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func fetchUserLocation() {
        locationManager.fetchUserLocation()
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }

    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }

}

extension MapViewModel: LocationManagerDelegate {
    func didUpdateLocation(_ location: CLLocation) {
        onLocationUpdated?(location.coordinate)
    }
    
    func didFailWithError(_ error: Error) {
        print("Erro ao obter localização: \(error.localizedDescription)")
    }
}
