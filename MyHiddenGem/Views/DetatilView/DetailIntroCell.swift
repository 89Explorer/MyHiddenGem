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
    
    private var iconImageView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    private let valueLabel: UILabel = UILabel()
    private let arrowImage: UIImageView = UIImageView()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    
    private func setupUI(){
        iconImageView.tintColor = .label
        iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.textColor = .label
        
        valueLabel.font = .systemFont(ofSize: 14)
        valueLabel.textColor = .secondaryLabel
        valueLabel.numberOfLines = 0
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        
        arrowImage.tintColor = .tertiaryLabel
        arrowImage.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let totalStack = UIStackView(arrangedSubviews: [iconImageView, textStack, arrowImage])
        totalStack.axis = .horizontal
        totalStack.spacing = 12
        totalStack.alignment = .center
        
        contentView.addSubview(totalStack)
        totalStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            totalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            totalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            totalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            totalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            
        ])
        
    }
    
    func configure(with introInfo: IntroInfo) {
        
        iconImageView.image = UIImage(systemName: "info.circle")
        titleLabel.text = "대표 메뉴"
        valueLabel.text = introInfo.mainMenu ?? "-"
        arrowImage.image = UIImage(systemName: "chevron.right")
        
    }
    
}


