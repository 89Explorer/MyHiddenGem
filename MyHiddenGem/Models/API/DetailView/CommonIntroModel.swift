//
//  CommonIntroModel.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/25/25.
//

import Foundation


// MARK: - Welcome
struct CommonWelcome: Codable {
    let response: CommonResponse
}

// MARK: - Response
struct CommonResponse: Codable {
    let header: CommonHeader
    let body: CommonBody
}

// MARK: - Body
struct CommonBody: Codable {
    let items: CommonItems
    let numOfRows, pageNo, totalCount: Int
}

// MARK: - Items
struct CommonItems: Codable {
    let item: [CommonIntroItem]
}

// MARK: - Item
struct CommonIntroItem: Codable {
    let contentid, contenttypeid, title, createdtime: String
    let modifiedtime, tel, telname, homepage: String
    let firstimage, firstimage2: String
    let cpyrhtDivCD, areacode, sigungucode, lDongRegnCD: String
    let lDongSignguCD, lclsSystm1, lclsSystm2, lclsSystm3: String
    let cat1, cat2, cat3, addr1: String
    let addr2, zipcode, mapx, mapy: String
    let mlevel, overview: String

    enum CodingKeys: String, CodingKey {
        case contentid, contenttypeid, title, createdtime, modifiedtime, tel, telname, homepage, firstimage, firstimage2
        case cpyrhtDivCD = "cpyrhtDivCd"
        case areacode, sigungucode
        case lDongRegnCD = "lDongRegnCd"
        case lDongSignguCD = "lDongSignguCd"
        case lclsSystm1, lclsSystm2, lclsSystm3, cat1, cat2, cat3, addr1, addr2, zipcode, mapx, mapy, mlevel, overview
    }
}

// MARK: - Header
struct CommonHeader: Codable {
    let resultCode, resultMsg: String
}
