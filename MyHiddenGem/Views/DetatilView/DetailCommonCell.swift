//
//  DetailCommonCell.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/25/25.
//

import UIKit

class DetailCommonCell: UICollectionViewCell {
    
    
    // MARK: - Variable
    
    static let reuseIdentifier: String = "DetailCommonCell"
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with eatery: CommonIntroItem) {
       
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let overviewView: InfoRowView = InfoRowView(
            title: "소개",
            image: "info.square",
            value: eatery.overview)
        
        let addressView: InfoRowView = InfoRowView(
            title: "주소",
            image: "mappin.square",
            value: eatery.addr1)
        
        stackView.addArrangedSubview(overviewView)
        stackView.addArrangedSubview(addressView)
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            
        ])
    }
    
}
