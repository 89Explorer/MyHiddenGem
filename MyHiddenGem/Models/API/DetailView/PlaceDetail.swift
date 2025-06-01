//
//  PlaceDetail.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/28/25.
//

import Foundation

/// 통합 데이터의 섹션 구분
enum DetailSectionType: Int, CaseIterable {
    case common
    case intro
    case image
    
    case map
    
    var title: String {
        switch self {
        case .common: return "기본 정보"
        case .intro: return "가게 정보"
        case .image: return "이미지"
        case .map: return "지도"
        }
    }
}

/// 통합 데이터의 아이템 구분
enum DetailItemType: Hashable {
    // case common(title: String, value: String?)
    /*
     위의 방식대로 하면 나오는 결과... (여러 셀이 생긴다.)
     DetailItemType.common(title: "주소", value: item.addr1)
     DetailItemType.common(title: "카테고리", value: item.cat3)
     */
    case common(info: CommonInfo)
    case intro(info: IntroInfo)
    case image(info: ImageListInfo)
    case map(info: Mapinfo)
}


/// 통합 데이터를 담기 위한 구조체 
struct DetailSection: Hashable {
    let type: DetailSectionType
    let item: [DetailItemType]
}


/// API를 통해 받아온 공통 정보 (Common Info)에서 필요로한 데이터만 모은 모델
struct CommonInfo: Hashable {
    let title: String?
    let cateogry: String?
    let address: String?
    let imageURL: String?
    let overview: String?
}


/// API를 통해 받아온 소개 정보 (Intro Info)에서 필요로한 데이터만 모은 모델
struct IntroInfo: Hashable {
    let mainMenu: String?
    let subMenu: String?
    let inquiry: String?
    let openTime: String?
    let restDay: String?
    let parking: String?
    let packing: String?
}

/// API를 통해 받아온 이미지 리스트 정보에서 필요로한 데이터만 모은 모델 
struct ImageListInfo: Hashable {
    let originalURL: String
    let imgName: String
    let serialnum: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(originalURL) // 또는 고유한 ID
    }

    static func == (lhs: ImageListInfo, rhs: ImageListInfo) -> Bool {
        return lhs.serialnum == rhs.serialnum // 또는 고유한 기준
    }
}


/// API를 통해 받아온 데이터 중에서 지도 데이터만 받아오기
struct Mapinfo: Hashable {
    let mapX: String
    let mapY: String
    let address: String
}


// MARK: - Struct: IntroItemMeta

/// IntroItemMeta 정의 – UI용 메타 정보
struct IntroItemMeta: Hashable {
    let keyPath: KeyPath<IntroInfo, String?>
    let title: String
    let systemImageNames: String
}





//enum DetailTotalSection {
//    case header
//    case introInfo
//    case detailImage
//    case locations
//}
//
//
//struct DetailSection {
//    let type: DetailTotalSection
//    let items: [DetailImageItems]
//}
//
//
//enum DetailTotalItem {
//    case image(urls: [String])
//    case info(title: String, value: String)
//}



