//
//  DetailIntroCell.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/29/25.
//

import UIKit

class DetailIntroCell: UICollectionViewCell {
    
    
    // MARK: - Variable
    
    static let reuseIdentifier: String = "DetailIntroCell"
    
    
    // MARK: - UI Component
    
    private let stackView: UIStackView = UIStackView()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    
    // MARK: - Function
    
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
//        contentView.layer.cornerRadius = 12
//        contentView.clipsToBounds = true
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    
    func configure(info: IntroInfo) {
        
        var packing = info.packing
        var parking = info.parking
        
        if packing?.count == 0 {
            packing = "_"
        }
        
        if parking?.count == 0{
            parking = "_"
        }
        
        let items: [(icon: String, title: String, value: String?)] = [
            ("fork.knife", "대표 메뉴", info.mainMenu),
            ("list.bullet", "부가 메뉴", info.subMenu),
            ("phone", "문의 및 안내", info.inquiry),
            ("clock", "영업 시간", info.openTime),
            ("calendar", "쉬는 날", info.restDay),
            ("parkingsign.square", "주차 여부", parking),
            ("backpack", "포장 여부", packing)
        ]
        
        for item in items {
            let view = TitleValueItemView(iconSystemName: item.icon, title: item.title, value: item.value)
            stackView.addArrangedSubview(view)
        }
    }
    
    func configure(overview: CommonInfo) {
        
       
        let items: [(icon: String, title: String, value: String?)] = [
            ("info.square", "가게 소개", overview.overview),
        ]
        
        for item in items {
            let view = TitleValueItemView(iconSystemName: item.icon, title: item.title, value: item.value)
            stackView.addArrangedSubview(view)
        }
    }
}


