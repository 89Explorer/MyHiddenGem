//
//  BottomMapView.swift
//  MyHiddenGem
//
//  Created by 권정근 on 6/2/25.
//

import UIKit

// BottomMapView.swift

class BottomMapView: UIView {
    
    
    // MARK: - Variable
    
    private var heightConstraint: NSLayoutConstraint!
    private var currentPosition: SheetPosition = .min
    
    
    // MARK: - UI Component
    private let searchBar: UISearchBar = UISearchBar()
    
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupGesture()
        
        setupSearchBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



// MARK: - 상태 관리
enum SheetPosition: CaseIterable {
    case min, mid, max
    
    var height: CGFloat {
        switch self {
        case .min: return 150
        case .mid: return UIScreen.main.bounds.height * 0.4
        case .max: return UIScreen.main.bounds.height * 0.85
        }
    }
}


// MARK: - Extension: BottomMapView가 UISheetPresentaion 느낌으로 설정

extension BottomMapView {
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowRadius = 5
    }
    
    
    /// BottomMapView 같은 커스텀 바텀 시트를 부모 뷰 (parentView)에 붙이고, 바텀 시트의 위치와 크기를 제약으로 고정해주는 초기 설정 메서드
    func attach(to parentView: UIView) {
        parentView.addSubview(self)
        heightConstraint = heightAnchor.constraint(equalToConstant: currentPosition.height)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor),
            heightConstraint
        ])
    }
    
    
    private func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGesture)
    }
    
    
    /// 팬 제스처(UIPanGestureRecognizer)를 통해 사용자가 BottomMapView를 위아래로 드래그할 수 있도록 해주는 메서드
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: superview)
        let velocity = gesture.velocity(in: superview)
        
        switch gesture.state {
        case .changed:
            let newHeight = heightConstraint.constant - translation.y
            heightConstraint.constant = max(SheetPosition.min.height,
                                            min(SheetPosition.max.height, newHeight))
            gesture.setTranslation(.zero, in: superview)
        case .ended:
            let nearest = nearestSheetPosition(to: heightConstraint.constant, velocity: velocity)
            animate(to: nearest)
        default:
            break
        }
    }
    
    /// 시트가 어느 정도 높이에 있는지 판단해서, 손을 떼면 어디에 "딱" 붙여야 할지를 계산하는 메서드
    private func nearestSheetPosition(to height: CGFloat, velocity: CGPoint) -> SheetPosition {
        let sorted = SheetPosition.allCases.sorted {
            abs($0.height - height) < abs($1.height - height)
        }
        
        if abs(velocity.y) > 500 {
            return velocity.y < 0 ? .max : .min
        } else {
            return sorted.first ?? .min
        }
    }
    
    private func animate(to position: SheetPosition) {
        currentPosition = position
        heightConstraint.constant = position.height
        UIView.animate(withDuration: 0.25) {
            self.superview?.layoutIfNeeded()
        }
    }
}


// MARK: - Extension: SearchBar 설정 하는 메서드

extension BottomMapView {
    
    private func setupSearchBar() {
        searchBar.placeholder = "검색어를 입력해주세요 😀"
        searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        searchBar.setImage(UIImage(systemName: "x.circle"), for: .clear, state: .normal)
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            //서치바 백그라운드 컬러
            textfield.backgroundColor = UIColor.systemGray6
            //플레이스홀더 글씨 색 정하기
            textfield.attributedPlaceholder = NSAttributedString(
                string: textfield.placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            //서치바 텍스트입력시 색 정하기
            textfield.textColor = UIColor.label
            //왼쪽 아이콘 이미지넣기
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                //이미지 틴트컬러 정하기
                leftView.tintColor = UIColor.label
            }
            //오른쪽 x버튼 이미지넣기
            //            if let rightView = textfield.rightView as? UIImageView {
            //                rightView.image = rightView.image?.withRenderingMode(.alwaysTemplate)
            //                //이미지 틴트 정하기
            //                rightView.tintColor = UIColor.label
            //            }
            
            
            // 오른쪽 x 버튼
            if let rightButton = textfield.rightView as? UIButton {
                let image = UIImage(systemName: "x.circle")?.withRenderingMode(.alwaysTemplate)
                rightButton.setImage(image, for: .normal)
                rightButton.tintColor = UIColor.label
            } else if let rightImageView = textfield.rightView as? UIImageView {
                rightImageView.image = rightImageView.image?.withRenderingMode(.alwaysTemplate)
                rightImageView.tintColor = UIColor.label
            }
            
        }
        
        setupSearchBarConstraints()
    }
    
    
    private func setupSearchBarConstraints() {
        
        addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 44)
            
        ])
    }
}
