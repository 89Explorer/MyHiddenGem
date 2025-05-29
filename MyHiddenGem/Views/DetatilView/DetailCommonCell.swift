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
    
    weak var delegate: DetailCommonCellDelegate?
    
    
    // MARK: - UI Component

//    private let addressView: TitleValueView = TitleValueView()
//    private let overviewView: TitleValueView = TitleValueView()
    private let mainStackView: UIStackView = UIStackView()
    private var introText: String?
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray6
        
        setupUI()
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    private func setupUI() {
//        
//        mainStackView.axis = .vertical
//        mainStackView.spacing = 12
//        mainStackView.alignment = .fill
//        
//        [addressView, overviewView].forEach {
//            mainStackView.addArrangedSubview($0)
//        }
//        
//        
//        mainStackView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(mainStackView)
//        
//        NSLayoutConstraint.activate([
//            
//            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
//            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
//            
//        ])
//    }

    
    private func setupUI() {
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        mainStackView.alignment = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            
        ])
    }
    

//    func configure(with item: CommonIntroItem) {
//        
//        let addressValue = item.addr1
//        let overviewValue = item.overview
//        
//        addressView.configure(title: "주소", value: addressValue)
//        overviewView.configure(title: "소개", value: overviewValue)
//    }
    
//    func configure(with items: [(title: String, value: String?)]) {
//        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
//        
//        for item in items {
//            let view = TitleValueView()
//            view.configure(title: item.title, value: item.value)
//            mainStackView.addArrangedSubview(view)
//            
//            
//            if item.title == "소개" {
//                introText = item.value
//                view.isUserInteractionEnabled = true
//                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleIntroTap))
//                view.addGestureRecognizer(tapGesture)
//            }
//        }
//    }
    
    
    ///
    @objc private func handleIntroTap() {
        delegate?.didTapIntroText(introText)
    }
}



// MARK: - Protocol: 소개 부분을 탭하면 더 보기 기능 활성화
protocol DetailCommonCellDelegate: AnyObject {
    func didTapIntroText(_ text: String?)
}


