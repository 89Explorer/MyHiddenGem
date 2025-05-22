//
//  EateryFromCategoryCell.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/21/25.
//

import UIKit
import SDWebImage

class EateryFromCategoryCell: UICollectionViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "EateryFromCategoryCell"
    
    
    // MARK: - UI Component
    
    private let title: UILabel = UILabel()
    private let address: UILabel = UILabel()
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
        address.text = nil
    }
    
    
    // MARK: - Function
    
    private func setupUI() {
        title.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 14, weight: .bold))
        title.textColor = .label
        title.textAlignment = .left
        title.numberOfLines = 1
        
        address.font = UIFont.preferredFont(forTextStyle: .caption1)
        address.textColor = .secondaryLabel
        address.numberOfLines = 0
        
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        let innerStackView = UIStackView(arrangedSubviews: [title, address])
        innerStackView.axis = .vertical
        innerStackView.spacing = 4
        
        let outterStackView = UIStackView(arrangedSubviews: [imageView, innerStackView])
        outterStackView.axis = .vertical
        outterStackView.alignment = .leading
        outterStackView.spacing = 8
        outterStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(outterStackView)
        
        NSLayoutConstraint.activate([
            
            outterStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            outterStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            outterStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            outterStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.heightAnchor.constraint(equalToConstant: 150)
            
        ])
        
    }
    
    /// 각 UI 에 데이터를 할당하는 함수
    func configure(with eateries: EateryItem) {
        
        title.text = eateries.title
        
        // 주소 정보를 " " 기준으로 나눠 주소 소개
        let components = eateries.addr1.split(separator: " ")
        if components.count >= 2 {
            address.text = components.prefix(2).joined(separator: " ")
        } else {
            address.text = eateries.addr1
        }
        
        let posterPath = URL(string: eateries.firstimage)
        self.imageView.sd_setImage(with: posterPath, completed: nil)
    }

}
