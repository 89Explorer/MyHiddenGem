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
    
    private var isExpanded: Bool = false
    private var stackViewBottomConstraint: NSLayoutConstraint?
    var onExpandToggle: (() -> Void)?  // 콜백
    
    // MARK: - UI Component
    
    private let tagLine: UILabel = UILabel()
    private let title: UILabel = UILabel()
    private let subTitle: UILabel = UILabel()
    private let imageView: UIImageView = UIImageView()
    private var stackView: UIStackView!
    
    private let basicView: UIView = UIView()
    private let overviewLabel: UILabel = UILabel()
    private let moreButton: UIButton = UIButton(type: .system)
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        setupCommonUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentView.subviews.forEach { $0.removeFromSuperview() }
        stackViewBottomConstraint?.isActive = false
        stackView = nil
        isExpanded = false
    }
    
    
    // MARK: - Function
    
    private func setupCommonUI() {
        
        tagLine.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .bold))
        tagLine.textColor = .systemBlue
        
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        title.textColor = .label
        
        subTitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subTitle.textColor = .secondaryLabel
        
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        overviewLabel.font = UIFont.preferredFont(forTextStyle: .body)
        overviewLabel.textColor = .label
        
        moreButton.setTitle("더보기", for:.normal)
        moreButton.setTitleColor(.systemBlue, for: .normal)
        
    }
    
    // MARK: - 추천용 셀 UI
    private func setupBasicUI() {
        //setupCommonUI()
        
        stackView = UIStackView(arrangedSubviews: [tagLine, title, subTitle, imageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 2
        stackView.axis = .vertical
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        imageView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        
        stackView.setCustomSpacing(10, after: subTitle)
    }
    
    
    // MARK: - 상세용 셀 UI
    private func setupDetailUI() {
        // setupCommonUI()
        
        stackView = UIStackView(arrangedSubviews: [tagLine, title, subTitle, imageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 2
        stackView.axis = .vertical
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        contentView.addSubview(basicView)
        basicView.addSubview(overviewLabel)
        basicView.addSubview(moreButton)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 300),
            
            basicView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            basicView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            basicView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            overviewLabel.leadingAnchor.constraint(equalTo: basicView.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: basicView.trailingAnchor),
            overviewLabel.topAnchor.constraint(equalTo: basicView.topAnchor),
            
            moreButton.centerXAnchor.constraint(equalTo: basicView.centerXAnchor),
            moreButton.bottomAnchor.constraint(equalTo: basicView.bottomAnchor, constant: -5),
            moreButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 10),
            moreButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
        
        imageView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        
        stackView.setCustomSpacing(10, after: subTitle)
        setupAction()
    }
    
    
    
    private func setupAction() {
        moreButton.addTarget(self, action: #selector(toggleOverview), for: .touchUpInside)
    }
    
    
    @objc private func toggleOverview() {
        isExpanded.toggle()
        overviewLabel.numberOfLines = isExpanded ? 0 : 3
        moreButton.setTitle(isExpanded ? "접기" : "더보기", for: .normal)
        onExpandToggle?()
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    
    func configure(with eateries: EateryItem) {
        //contentView.subviews.forEach { $0.removeFromSuperview() }
        setupBasicUI()
        
        tagLine.text = CategoryCodeMapper.name(for: eateries.cat3)
        title.text = eateries.title
        subTitle.text = eateries.addr1
        
        if let url = URL(string: eateries.firstimage) {
            imageView.sd_setImage(with: url)
        }
    }
    
    
    func configure(with commonInfo: CommonInfo, isExpanded: Bool = false) {
        //contentView.subviews.forEach { $0.removeFromSuperview() }
        
        setupDetailUI()
        
        tagLine.text = commonInfo.cateogry.flatMap { CategoryCodeMapper.name(for: $0) } ?? "⚪️ 기타"
        title.text = commonInfo.title
        subTitle.text = commonInfo.address
        overviewLabel.text = commonInfo.overview
        self.isExpanded = isExpanded
        overviewLabel.numberOfLines = isExpanded ? 0 : 3
        moreButton.setTitle(isExpanded ? "접기" : "더보기", for: .normal)
        
        if let url = commonInfo.imageURL.flatMap({ URL(string: $0) }) {
            imageView.sd_setImage(with: url)
        }
    }
    
    
}
