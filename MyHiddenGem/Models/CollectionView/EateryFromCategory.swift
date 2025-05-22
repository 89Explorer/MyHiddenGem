//
//  EateryFromCategory.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/21/25.
//

import Foundation


/// 카테고리를 통해 받아온 데이터를 구분하는 섹션
enum EateryFromCategorySection: Int, CaseIterable {
    case category    // 전체 음식점 리스트
    
    var title: String {
        switch self {
        case .category: return "전체 카테고리"
        }
    }
}


/// 카테고리를 통해 받아온 데이터를 담는 아이템 
enum EateryFromCategoryType: Hashable {
    case category(EateryItem)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .category(let value):
            hasher.combine(value.contentid)
        }
    }
    
    static func == (lhs: EateryFromCategoryType, rhs: EateryFromCategoryType) -> Bool {
        switch (lhs, rhs) {
        case (.category(let a), .category(let b)):
            return a.contentid == b.contentid
        }
    }
}
