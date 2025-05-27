//
//  DetailImageCell.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/26/25.
//

import UIKit
import SDWebImage

class DetailImageCell: UICollectionViewCell {
    
    
    // MARK: - Variable
    
    static let reuseIdentifier: String = "DetailImageCell"
    
    
    // MARK: - UI Component
    
    private let imageView: UIImageView = UIImageView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .systemGray6
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    
    private func setupUI() {
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
    
    
    func configure(with item: DetailImageItem) {
        
        let posterPath = URL(string: item.originimgurl)
        
        loadingIndicator.startAnimating()
        imageView.sd_setImage(with: posterPath, placeholderImage: nil) {_,_,_,_ in 
            self.loadingIndicator.stopAnimating()
        }
    }
    
}
