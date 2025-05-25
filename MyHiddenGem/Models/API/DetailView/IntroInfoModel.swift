//
//  IntroInfoModel.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/25/25.
//

import Foundation


// MARK: - Welcome
struct IntroInfoWelcome: Codable {
    let response: IntroInfoResponse
}

// MARK: - Response
struct IntroInfoResponse: Codable {
    let header: IntroInfoHeader
    let body: IntroInfoBody
}

// MARK: - Body
struct IntroInfoBody: Codable {
    let items: IntroInfoItems
    let numOfRows, pageNo, totalCount: Int
}

// MARK: - Items
struct IntroInfoItems: Codable {
    let item: [IntroInfoItem]
}

// MARK: - Item
struct IntroInfoItem: Codable, Hashable {
    let contentid: String
    let contenttypeid: String
    let seat: String?
    let kidsfacility: String?
    let firstmenu: String?
    let treatmenu: String?
    let smoking: String?
    let packing: String?
    let infocenterfood: String?
    let scalefood: String?
    let parkingfood: String?
    let opendatefood: String?
    let opentimefood: String?
    let restdatefood: String?
    let discountinfofood: String?
    let chkcreditcardfood: String?
    let reservationfood: String?
    let lcnsno: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(contentid)
    }
}



// MARK: - Header
struct IntroInfoHeader: Codable {
    let resultCode, resultMsg: String
}


