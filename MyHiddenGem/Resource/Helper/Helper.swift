//
//  Helper.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/25/25.
//

import Foundation
import UIKit

/// UILabel에 패딩을 주는 클래스
class BasePaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
}

/// 컬렉션 뷰 셀에 표시될 셀의 UI
//final class InfoRowView: UIStackView {
//    private let iconImageView: UIImageView = UIImageView()
//    private let titleLabel = UILabel()
//    private let valueLabel = UILabel()
//    
//    init(title: String, image: String, value: String) {
//        super.init(frame: .zero)
//        self.layer.cornerRadius = 8
//        self.clipsToBounds = true
//        self.backgroundColor = .systemBackground
//        setup(title: title, image: image, value: value)
//    }
//    
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setup(title: String, image: String, value: String) {
//        
//        let configuration = UIImage.SymbolConfiguration(pointSize: 25)
//        iconImageView.image = UIImage(systemName: image, withConfiguration: configuration)
//        iconImageView.contentMode = .scaleAspectFill
//        iconImageView.clipsToBounds = true
//        iconImageView.tintColor = UIColor.label
//        //iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        
//        titleLabel.font = .preferredFont(forTextStyle: .title3)
//        titleLabel.text = title
//        titleLabel.textColor = .systemBlue
//        
//        valueLabel.font = .preferredFont(forTextStyle: .body)
//        valueLabel.text = value
//        valueLabel.numberOfLines = 0
//        valueLabel.textColor = .label
//        
//        let textStack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
//        textStack.axis = .vertical
//        textStack.spacing = 5
//        textStack.alignment = .leading
//        textStack.distribution = .fill
//        
//        self.axis = .horizontal
//        self.spacing = 10
//        self.alignment = .center
//        self.addArrangedSubview(iconImageView)
//        self.addArrangedSubview(textStack)
//        self.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//    }
//}


/// 상세페이지 내에 각 셀에 공용으로 사용될 UI
final class TitleValueView: UIView {
    
    // MARK: - UI Component
    private let titleLabel: UILabel = UILabel()
    private let valueLabel: BasePaddingLabel = BasePaddingLabel()
    
    
    init(title: String = "", value: String = "") {
        super.init(frame: .zero)
        setupUI()
        configure(title: title, value: value)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func setupUI() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .label
        
        valueLabel.font = UIFont.preferredFont(forTextStyle: .body)
        valueLabel.numberOfLines = 3
        valueLabel.textColor = .label
        valueLabel.backgroundColor = .systemBackground
        valueLabel.layer.cornerRadius = 10
        valueLabel.clipsToBounds = true
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        //stackView.distribution = .fill
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
    
    func configure(title: String?, value: String?) {
        
        guard let title = title,
              let value = value else { return }
        
        titleLabel.text = title
        valueLabel.text = value
    }
    
}
