//
//  EaterySection.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/14/25.
//

import Foundation

/// recommendationCollectionView 의 섹션 구분 목적
enum EaterySection: Int, CaseIterable {
    case category    // 음식점 카테고리
    case list        // 음식점 리스트
    
    var title: String {
        switch self {
        case .category: return "카테고리"
        case .list:     return "음식점"
        }
    }
}


enum EateryItemType: Hashable {
    case category(CategoryEmogi)
    case eatery(EateryItem)
    
    // Hashable 지원
    func hash(into hasher: inout Hasher) {
        switch self {
        case .category(let category):
            hasher.combine(category.name)
        case .eatery(let eatery):
            hasher.combine(eatery.contentid)
        }
    }
    
    static func == (lhs: EateryItemType, rhs: EateryItemType) -> Bool {
        switch (lhs, rhs) {
        case (.category(let a), .category(let b)):
            return a.name == b.name
        case (.eatery(let a), .eatery(let b)):
            return a.contentid == b.contentid
        default:
            return false
        }
    }
}
