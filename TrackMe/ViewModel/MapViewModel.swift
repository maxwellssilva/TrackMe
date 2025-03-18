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
    
    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
}

extension MapViewModel: LocationManagerDelegate {
    func didUpdateLocation(_ location: CLLocation) {
        onLocationUpdate?(location.coordinate)
    }
    
    func didFailWithError(_ error: Error) {
        print("Erro ao obter localização: \(error.localizedDescription)")
    }
}
