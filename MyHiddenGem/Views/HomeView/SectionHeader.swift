//
//  SectionHeader.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/16/25.
//

import UIKit

class SectionHeader: UICollectionReusableView {
        
    
    // MARK: - Variable
    static let reuseIdentifier: String = "SectionHeader"
    
    
    // MARK: - UI Component
    private let title: UILabel = UILabel()
    private let subTitle: UILabel = UILabel()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func setupUI() {
        let separator: UIView = UIView(frame: .zero)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .quaternaryLabel
        
        title.textColor = .label
        title.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 22, weight: .bold))
        title.textAlignment = .left
        
        subTitle.textColor = .secondaryLabel
        subTitle.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 14, weight: .semibold))
        
        let stackView = UIStackView(arrangedSubviews: [separator, title, subTitle])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            separator.heightAnchor.constraint(equalToConstant: 2),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
            
        ])
        
        stackView.setCustomSpacing(10, after: separator)
    }
    
    
    func configure(main: String, sub: String) {
        title.text = main
        subTitle.text = sub
    }
}
