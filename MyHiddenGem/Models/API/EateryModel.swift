//
//  EateryModel.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/14/25.
//

import Foundation

// MARK: - EateryWelcome
struct EateryWelcome: Codable {
    let response: EateryResponse
}

// MARK: - EateryResponse
struct EateryResponse: Codable {
    let header: EateryHeader
    let body: EateryBody
}

// MARK: - EateryBody
struct EateryBody: Codable {
    let items: EateryItems
    let numOfRows, pageNo, totalCount: Int
}

// MARK: - EateryItems
struct EateryItems: Codable {
    let item: [EateryItem]
}

// MARK: - EateryItem
struct EateryItem: Codable {
    let addr1, addr2, areacode: String
    let cat1: Cat1
    let cat2: Cat2
    let cat3, contentid, contenttypeid, createdtime: String
    let firstimage, firstimage2: String
    let cpyrhtDivCD: CpyrhtDivCD
    let mapx, mapy, mlevel, modifiedtime: String
    let sigungucode, tel, title, zipcode: String
    let lDongRegnCD, lDongSignguCD: String
    let lclsSystm1: LclsSystm1
    let lclsSystm2: LclsSystm2
    let lclsSystm3: String

    enum CodingKeys: String, CodingKey {
        case addr1, addr2, areacode, cat1, cat2, cat3, contentid, contenttypeid, createdtime, firstimage, firstimage2
        case cpyrhtDivCD = "cpyrhtDivCd"
        case mapx, mapy, mlevel, modifiedtime, sigungucode, tel, title, zipcode
        case lDongRegnCD = "lDongRegnCd"
        case lDongSignguCD = "lDongSignguCd"
        case lclsSystm1, lclsSystm2, lclsSystm3
    }
}

enum Cat1: String, Codable {
    case a05 = "A05"
}

enum Cat2: String, Codable {
    case a0502 = "A0502"
}

enum CpyrhtDivCD: String, Codable {
    case type3 = "Type3"
}

enum LclsSystm1: String, Codable {
    case fd = "FD"
}

enum LclsSystm2: String, Codable {
    case fd01 = "FD01"
    case fd02 = "FD02"
    case fd05 = "FD05"
}

// MARK: - EateryHeader
struct EateryHeader: Codable {
    let resultCode, resultMsg: String
}
