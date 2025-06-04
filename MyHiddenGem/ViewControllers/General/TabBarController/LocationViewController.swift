//
//  LocationViewController.swift
//  MyHiddenGem
//
//  Created by 권정근 on 4/23/25.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController {
    
    // MARK: - Variable
    private var mapX: Double = 37.5665
    private var mapY: Double = 126.9780
    
    let status = CLLocationManager().authorizationStatus
    let locationManager = CLLocationManager()
    
    
    var isModal: Bool {
        if let navigationController = navigationController {
            if navigationController.viewControllers.first != self {
                return false
            }
        }
        if presentingViewController != nil {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        }
        if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    
    // MARK: - UI Component
    private var mapView = MKMapView()
    private let bottomSheet = BottomMapView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupMapView()
        centerMapOnInitialLocation()
        
        if isModal {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .close,
                target: self,
                action: #selector(didTapClose)
            )
        } else {
            bottomSheet.attach(to: self.view)
        }
        
        requestLocationAccess()
        setupLocationButton()
    }
    
    func requestLocationAccess() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // ⛔️ startUpdatingLocation()은 여기서 호출하지 않음!
    }

    
    
    
    // MARK: - Init
    
    init(mapX: Double, mapY: Double) {
        self.mapX = mapX
        self.mapY = mapY
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    
    private func setupMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        mapView.showsUserLocation = true    // 현재 내위치 표시
        mapView.userTrackingMode = .none    // 사용자 위치를 수동으로 추적
        
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
    
    
    // MARK: Action Method
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - Extension: 위치 권한 설정

extension LocationViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("위치 권한 거부됨")
        case .notDetermined:
            print("아직 권한 요청 전")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("현재 위치: \(latitude), \(longitude)")
            
            // 필요하다면 지도 위치도 이동 가능
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            
            // 한 번만 받아오고 멈추려면
            locationManager.stopUpdatingLocation()
        }
    }
    
    private func setupLocationButton() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.circle"), for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLocationButton), for: .touchUpInside)
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: bottomSheet.topAnchor, constant: -20),
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    @objc private func didTapLocationButton() {
        guard let location = locationManager.location else {
            print("현재 위치 정보를 가져올 수 없습니다.")
            return
        }

        let coordinate = location.coordinate
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }

}

