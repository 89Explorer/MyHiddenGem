//
//  RecommendationCell.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/8/25.
//

import UIKit
import SDWebImage

class RecommendationCell: UICollectionViewCell {
    
    // MARK: - Variable
    
    static let reuseIdentifier: String = "RecommendationCell"
    
    
    // MARK: - UI Component
    
    private let tagLine: UILabel = UILabel()
    private let title: UILabel = UILabel()
    private let subTitle: UILabel = UILabel()
    private let imageView: UIImageView = UIImageView()
    
    
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
    
    /// UI 설정 함수
    private func setupUI() {
        tagLine.font = UIFontMetrics.default.scaledFont(
            for: UIFont.systemFont(ofSize: 12, weight: .bold))
        tagLine.textColor = .systemBlue
        
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        title.textColor = .label
        
        subTitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subTitle.textColor = .secondaryLabel
        
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        let stackView = UIStackView(arrangedSubviews: [tagLine, title, subTitle, imageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 2
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
        
        stackView.setCustomSpacing(10, after: subTitle)
        
    }
    
    
    /// 각 UI에 데이터를 할당하는 함수
    func configure(with eateries: EateryItem) {
        
        let categoryCodeMap = CategoryCodeMapper.name(for: eateries.cat3)
        
        tagLine.text = categoryCodeMap
        title.text = eateries.title
        subTitle.text = eateries.addr1
        
        let posterPath = URL(string: eateries.firstimage)
        imageView.sd_setImage(with: posterPath, completed: nil)
        
    }
    
    
    /// 상세 페이지 내에 공용으로 사용할 목적으로 메서드
    func configure(with commonInfo: CommonInfo) {
        
        if let categoryCode = commonInfo.cateogry {
//            tagLine.text = CategoryCodeMapper.emojiName(for: categoryCode)
            
            tagLine.text = CategoryCodeMapper.name(for: categoryCode)
        } else {
            tagLine.text = "⚪️ 기타"
        }
    
        title.text = commonInfo.title
        subTitle.text = commonInfo.address
        
        guard let imageURL = commonInfo.imageURL else { return }
        let posterPath = URL(string: imageURL)
        imageView.sd_setImage(with: posterPath, completed: nil)
    }
    
}
