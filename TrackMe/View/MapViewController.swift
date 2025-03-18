//
//  ViewController.swift
//  TrackMe
//
//  Created by Maxwell Silva on 17/03/25.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, LocationManagerDelegate {
    
    private let locationManager = LocationManager()
    private let viewModel = MapViewModel()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Pesquise por um local"
        searchBar.tintColor = .systemBackground
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let mapView: MapView = {
        let map = MapView()
        map.layer.cornerRadius = 12
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupLayout()
        
        locationManager.delegate = self
        locationManager.requestLocationPermission()
        locationManager.startUpdatingLocation()
    }

    private func setupNavigationBar() {
        title = "TrackMe"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupBindings() {
        viewModel.onLocationUpdate = { [weak self] coordinate in
            DispatchQueue.main.async {
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                self?.mapView.getMapView().setRegion(region, animated: true)
            }
        }
    }
    
    private func setupLayout() {
        view.addSubview(searchBar)
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            
            mapView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
    }
    
    func didUpdateLocation(_ location: CLLocation) {
        let coordinate = location.coordinate
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.getMapView().setRegion(region, animated: true)
    }
    
    func didFailWithError(_ error: any Error) {
        print("Erro ao obter localização: \(error.localizedDescription)")
    }
}

