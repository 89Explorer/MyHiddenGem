//
//  CategoryCell.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/15/25.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    // MARK: - Variable
    static let reuseIdentifier: String = "CategoryCell"
    
    
    // MARK: - UI Component
    private let label: UILabel = UILabel()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func setupUI() {
        label.font = UIFontMetrics.default.scaledFont(
            for: UIFont.systemFont(ofSize: 14, weight: .bold))
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            
        ])
    }
    
    func configure(with category: String) {
        label.text = category
    }
}
