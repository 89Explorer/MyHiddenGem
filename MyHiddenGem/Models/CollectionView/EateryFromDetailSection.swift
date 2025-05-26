//
//  EateryFromDetailSection.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/25/25.
//

import Foundation


/// contentId와 contentTypeId을 통해 받아온 음식점 데이터를 구분하는 섹션
enum EateryFromDetailSection: Int, CaseIterable {
    case header
    case common
    case detailImage
    //case eateryInfo
    
    var title: String {
        switch self {
        case .header: return "헤더뷰"
        case .common: return "공통정보"
        case .detailImage: return "상세 이미지"
        //case .eateryInfo: return "소개"
        }
    }
}


/// contentId와 contentTypeId를 통해 받아온 음석점 데이터를 담는 아이템
enum EateryFromDetailType: Hashable {
    case header(EateryFromDetailHeader)
    case common(CommonIntroItem)
    case detailImage(DetailImageItem)
    //case eateryInfo(IntroInfoItem)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .header(let value):
            hasher.combine(value.contentId)
        case .common(let value):
            hasher.combine(value.contentid)
        case .detailImage(let value):
            hasher.combine(value.originimgurl)
//        case .eateryInfo(let value):
//            hasher.combine(value.contentid)
        }
    }
    
    static func == (lhs: EateryFromDetailType, rhs: EateryFromDetailType) -> Bool {
        switch(lhs, rhs) {
        case (.header(let a), .header(let b)):
            return a.contentId == b.contentId
        case (.common(let a), .common(let b)):
            return a.contentid == b.contentid
        case (.detailImage(let a), .detailImage(let b)):
            return a.originimgurl == b.originimgurl
//        case (.eateryInfo(let a), .eateryInfo(let b)):
//            return a.contentid == b.contentid
        default:
            return false
        }
    }
}



/// 헤더뷰 부분 아이템
struct EateryFromDetailHeader: Hashable {
    
    let contentId: String
    let contentType: String
    let eateryTitle: String
    let posterPath: String
    let cat3: String
    
}
