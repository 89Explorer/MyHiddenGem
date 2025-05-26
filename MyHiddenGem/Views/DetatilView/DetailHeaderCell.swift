//
//  DetailHeaderCell.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/25/25.
//

import UIKit

class DetailHeaderCell: UICollectionViewCell {
    
    
    // MARK: - Variable
    
    static let reuseIdentifier: String = "DetailHeaderCell"
    
    
    // MARK: - UI Component
    
    private let imageView: UIImageView = UIImageView()
    private let introLabel: BasePaddingLabel = BasePaddingLabel()
    private let categoryLabel: BasePaddingLabel = BasePaddingLabel()
    
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        introLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        introLabel.backgroundColor = .systemGray6
        introLabel.textColor = .label
        introLabel.layer.cornerRadius = 8
        introLabel.clipsToBounds = true
        
        categoryLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        categoryLabel.backgroundColor = .systemGray6
        categoryLabel.textColor = .secondaryLabel
        categoryLabel.layer.cornerRadius = 4
        categoryLabel.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        introLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        contentView.addSubview(introLabel)
        contentView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            categoryLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 20),
            categoryLabel.bottomAnchor.constraint(equalTo: introLabel.topAnchor, constant: -10),
            
            introLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 20),
            introLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -20)
            
        ])
    }
    
    
    /// 각 UI에 데이터를 할당하는 함수
    func configure(headerData: EateryFromDetailHeader ) {
        
        let posterPath = URL(string: headerData.posterPath)
        self.imageView.sd_setImage(with: posterPath, completed: nil)
        
        introLabel.text = headerData.eateryTitle
    
        categoryLabel.text = CategoryCodeMapper.emojiName(for: headerData.cat3)
        
    }
    
}


