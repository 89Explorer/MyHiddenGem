//
//  EateryFromRegionSection.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/22/25.
//

import Foundation


/// 지역코드를 통해 받아온 음식점 리스트 데이터를 구분하는 섹션
enum EateryFromRegionSection: Int, CaseIterable {
    case category
    case region
    
    var title: String {
        switch self {
        case .category: return "카테고리"
        case .region: return "지역"
        }
    }
}



/// 지역코드를 통해 받아온 음식점 데이터를 담는 아이템
enum EateryFromRegionType: Hashable {
    case category(CategoryEmogi)
    case region(EateryItem)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .category(let value):
            hasher.combine(value.name)
        case .region(let value):
            hasher.combine(value.contentid)
        }
    }
    
    static func == (lhs: EateryFromRegionType, rhs: EateryFromRegionType) -> Bool {
        switch (lhs, rhs) {
        case (.category(let a), .category(let b)):
            return a.name == b.name
        case (.region(let a), .region(let b)):
            return a.contentid == b.contentid
        default:
            return false
        }
    }
}
