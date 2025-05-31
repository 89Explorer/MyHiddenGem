//
//  DetailOverviewCell.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/30/25.
//

import UIKit

class DetailOverviewCell: UICollectionViewCell {
    
    // MARK: - Variable
    
    static let reuseIdentifier: String = "DetailOverviewCell"
    private var isExpanded: Bool = false
    
    
    
    // MARK: - UI Component
    
    private let basicView: UIView = UIView()
    private let overviewLabel: UILabel = UILabel()
    private let moreButton: UIButton = UIButton(type: .system)
    
    
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
        
        contentView.backgroundColor = .systemBackground
     
        overviewLabel.font = .systemFont(ofSize: 12, weight: .regular)
        overviewLabel.numberOfLines = 3
        overviewLabel.lineBreakMode = .byTruncatingTail
        overviewLabel.textColor = .label
        
        moreButton.setTitle("더 보기", for: .normal)
        moreButton.setTitleColor(.systemBlue, for: .normal)
        moreButton.titleLabel?.font = .boldSystemFont(ofSize: 12)
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(basicView)
        basicView.addSubview(overviewLabel)
        basicView.addSubview(moreButton)
        
        NSLayoutConstraint.activate([
            
            basicView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            basicView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            basicView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            basicView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            overviewLabel.leadingAnchor.constraint(equalTo: basicView.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: basicView.trailingAnchor),
            overviewLabel.topAnchor.constraint(equalTo: basicView.topAnchor),
            
            moreButton.leadingAnchor.constraint(equalTo: basicView.leadingAnchor),
            moreButton.trailingAnchor.constraint(equalTo: basicView.trailingAnchor),
            moreButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 8)
        ])
        
    }
    
    private func setupAction() {
        moreButton.addTarget(self, action: #selector(toggleOverview), for: .touchUpInside)
    }
    
    func configure(with item: CommonInfo, isExpanded: Bool = false) {
        overviewLabel.text = item.overview
        self.isExpanded = isExpanded
        overviewLabel.numberOfLines = isExpanded ? 0 : 3
        moreButton.setTitle(isExpanded ? "접기" : "더보기", for: .normal)
    }
    
    @objc private func toggleOverview() {
        isExpanded.toggle()
        overviewLabel.numberOfLines = isExpanded ? 0 : 3
        moreButton.setTitle(isExpanded ? "접기" : "더보기", for: .normal)
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    
    
}
