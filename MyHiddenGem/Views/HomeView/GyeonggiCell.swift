//
//  GyeonggiCell.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/16/25.
//

import UIKit
import SDWebImage

class GyeonggiCell: UICollectionViewCell {
    
    // MARK: - Variable
    
    static let reuseIdentifier: String = "GyeonggiCell"
    
    
    // MARK: - UI Component
    
    private let tagLabel: UILabel = UILabel()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    
    // MARK: - Function
    
    private func setupUI() {
        tagLabel.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .bold))
        tagLabel.textColor = .systemBlue
        
        title.font = UIFont.preferredFont(forTextStyle: .body)
        title.textColor = .label
        
        subTitle.font = UIFont.preferredFont(forTextStyle: .caption2)
        subTitle.textColor = .secondaryLabel
        
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let innerStackView = UIStackView(arrangedSubviews: [tagLabel, title, subTitle])
        innerStackView.axis = .vertical
        innerStackView.spacing = 4
        
        let outterStackView = UIStackView(arrangedSubviews: [innerStackView, imageView])
        outterStackView.translatesAutoresizingMaskIntoConstraints = false
        outterStackView.axis = .horizontal
        outterStackView.alignment = .center
        outterStackView.spacing = 8
        contentView.addSubview(outterStackView)
        
        NSLayoutConstraint.activate([
            
            outterStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            outterStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            outterStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            outterStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            
            imageView.widthAnchor.constraint(equalToConstant: 80)
            
        ])
        
    }
    
    /// 각 UI에 데이터를 할당하는 함수
    func configure(with eateries: EateryItem) {
        
        let categoryCodeMap = CategoryCodeMapper.name(for: eateries.cat3)
        
        tagLabel.text = categoryCodeMap
        title.text = eateries.title
        subTitle.text = eateries.addr1
        
        
        let posterPath = URL(string: eateries.firstimage)
        self.imageView.sd_setImage(with: posterPath, completed: nil)
        
    }

}
