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
    case gyeonggido  // 경기 음식점
    case seoul       // 서울 음식점
    case incheon     // 인천 음식점
    
    var title: String {
        switch self {
        case .category: return "카테고리"
        case .list:     return "음식점"
        case .gyeonggido: return "경기도"
        case .seoul: return "서울"
        case .incheon: return "인천"
        }
    }
}


enum EateryItemType: Hashable {
    case category(CategoryEmogi)
    case eatery(EateryItem)
    case gyeonggido(EateryItem)
    case seoul(EateryItem)
    case incheon(EateryItem)
    
    // Hashable 지원
    func hash(into hasher: inout Hasher) {
        switch self {
        case .category(let category):
            hasher.combine(category.name)
        case .eatery(let eatery):
            hasher.combine(eatery.contentid)
        case .gyeonggido(let eatery):
            hasher.combine(eatery.contentid)
        case .seoul(let eatery):
            hasher.combine(eatery.contentid)
        case .incheon(let eatery):
            hasher.combine(eatery.contentid)
        }
    }
    
    static func == (lhs: EateryItemType, rhs: EateryItemType) -> Bool {
        switch (lhs, rhs) {
        case (.category(let a), .category(let b)):
            return a.name == b.name
        case (.eatery(let a), .eatery(let b)):
            return a.contentid == b.contentid
        case (.gyeonggido(let a), .gyeonggido(let b)):
            return a.contentid == b.contentid
        case (.seoul(let a), .seoul(let b)):
            return a.contentid == b.contentid
        case (.incheon(let a), .incheon(let b)):
            return a.contentid == b.contentid
        default:
            return false
        }
    }
}
