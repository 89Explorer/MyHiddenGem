//
//  DetailMapInfoCell.swift
//  MyHiddenGem
//
//  Created by 권정근 on 6/1/25.
//

import UIKit
import MapKit

class DetailMapInfoCell: UICollectionViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "DetailMapInfoCell"
    
    
    // MARK: - UI Component
    
    private let containerView: UIView = UIView()
    private let mapView: MKMapView = MKMapView()
    private let addressLabel: UILabel = UILabel()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    
    private func setupUI() {
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true 
        
 
        mapView.isUserInteractionEnabled = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        addressLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        addressLabel.textAlignment = .center
        addressLabel.textColor = .label
        addressLabel.numberOfLines = 1
        addressLabel.textAlignment = .left
        
    
        contentView.addSubview(containerView)
        
        containerView.addSubview(mapView)
        containerView.addSubview(addressLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
          
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            mapView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: containerView.topAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 250),
            
            addressLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            addressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            addressLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 8),
            addressLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)

            
        ])
    }
    
    
    func configure(with item: Mapinfo) {
        addressLabel.text = item.address
        
        guard let lat = Double(item.mapY),
              let lon = Double(item.mapX)
        else { return }
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        
        mapView.setRegion(region, animated: false)
        
        let annotaion = MKPointAnnotation()
        annotaion.coordinate = coordinate
        mapView.addAnnotation(annotaion)
    }
}
