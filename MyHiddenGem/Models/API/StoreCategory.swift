//
//  StoreCategory.swift
//  MyHiddenGem
//
//  Created by 권정근 on 4/24/25.
//

import Foundation

// ✅ 음식점 카테고리 데이터 모델
struct StoreCategory: Codable {
    let code: String
    let name: String
    let rnum: Int
}

struct CategoryResponse: Codable {
    let response: ResponseBody
}

struct ResponseBody: Codable {
    let body: ResponseItems
}


struct ResponseItems: Codable {
    let items: ItemList
}


struct ItemList: Codable {
    let item: [StoreCategory]
}


/// 이모지를 폼할할 새 모델
struct CategoryEmogi: Hashable {
    let id = UUID()
    let code: String
    let name: String
    let icon: String
    var isSelected: Bool = false 
    
    var displayName: String {
        return "\(icon) \(name)"
    }
}


/// 음식점 카테고리 코드를 한글로 매핑
struct CategoryCodeMapper {
    static let codeMap: [String: String] = [
        "A05020100": "한식",
        "A05020200": "서양식",
        "A05020300": "일식",
        "A05020400": "중식",
        "A05020700": "이색음식점",
        "A05020900": "카페/전통찻집",
        "A05021000": "클럽"
    ]
    
    
    static func name(for code: String) -> String {
        return codeMap[code] ?? "기타 "
    }
}
