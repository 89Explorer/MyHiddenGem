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


