//
//  DetailImageList.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/26/25.
//

import Foundation

// MARK: - Welcome
struct DetailImageWelcome: Codable {
    let response: DetailImageResponse
}

// MARK: - Response
struct DetailImageResponse: Codable {
    let header: DetailImageHeader
    let body: DetailImageBody
}

// MARK: - Body
struct DetailImageBody: Codable {
    let items: DetailImageItems
    let numOfRows, pageNo, totalCount: Int
}

// MARK: - Items
struct DetailImageItems: Codable {
    let item: [DetailImageItem]
}

// MARK: - Item
struct DetailImageItem: Codable {
    let contentid: String
    let originimgurl: String
    let imgname: String
    let smallimageurl: String
    let cpyrhtDivCD, serialnum: String

    enum CodingKeys: String, CodingKey {
        case contentid, originimgurl, imgname, smallimageurl
        case cpyrhtDivCD = "cpyrhtDivCd"
        case serialnum
    }
}

// MARK: - Header
struct DetailImageHeader: Codable {
    let resultCode, resultMsg: String
}
