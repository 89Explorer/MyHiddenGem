//
//  LocationViewController.swift
//  MyHiddenGem
//
//  Created by 권정근 on 4/23/25.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {
    
    
    // MARK: - UI Component
    private var mapView = MKMapView()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupMapView()
        centerMapOnInitialLocation()
    }
    
    
    // MARK: - Function
    
    private func setupMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    
    private func centerMapOnInitialLocation() {
        
        // 예시: 서울 시청 좌표
        let seoulCityHall = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
        let region = MKCoordinateRegion(center: seoulCityHall,
                                        latitudinalMeters: 1000,
                                        longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
}
