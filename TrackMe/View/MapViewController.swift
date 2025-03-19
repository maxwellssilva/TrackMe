//
//  ViewController.swift
//  TrackMe
//
//  Created by Maxwell Silva on 17/03/25.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, LocationManagerDelegate, UISearchBarDelegate {
    
    private let locationManager = LocationManager()
    private let viewModel = MapViewModel()
    private var isUserInteractingWithMap = false
    private let geocoder = CLGeocoder()
    
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
        setupBindings()
        searchBar.delegate = self
        
        locationManager.delegate = self
        mapView.getMapView().delegate = self
        locationManager.requestUserLocationPermission()
        viewModel.startLocationUpdates()
    }

    private func setupNavigationBar() {
        title = "TrackMe"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupBindings() {
        // Recebe a atualização da localização no ViewModel e atualiza o mapa
        viewModel.onLocationUpdated = { [weak self] coordinate in
            DispatchQueue.main.async {
                if !self!.isUserInteractingWithMap {
                    let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                    self?.mapView.getMapView().setRegion(region, animated: true)
                }
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                print("Erro: \(errorMessage)")
            }
        }
    }
    
    func didUpdateLocation(_ location: CLLocation) {
        if !isUserInteractingWithMap {
            viewModel.fetchUserLocation() // Atualiza a localização no ViewModel
        }
    }
    
    func didFailWithError(_ error: Error) {
        print("Erro ao obter localização: \(error.localizedDescription)")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
            
        geocoder.geocodeAddressString(searchText) { [weak self] (placemarks, error) in
            if let error = error {
                print("Erro ao geocodificar: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first, let location = placemark.location {
                self?.centerMapOnLocation(location: location) // Centraliza o mapa após encontrar a localização
                searchBar.resignFirstResponder() // Esconde o teclado
            } else {
                print("Local não encontrado.")
            }
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.getMapView().setRegion(region, animated: true)
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
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        isUserInteractingWithMap = true
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !isUserInteractingWithMap {
            viewModel.fetchUserLocation()
        }
    }
}
