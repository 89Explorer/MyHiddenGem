//
//  DetailViewModel.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/25/25.
//

import Foundation
import Combine

@MainActor
class DetailViewModel: ObservableObject {
    
    // MARK: - Variable
    @Published var detailIntro: [IntroInfoItem] = []
    @Published var commonIntro: [CommonIntroItem] = []
    @Published var detailImageList: [DetailImageItem] = []
    
    @Published var detailTotalModel: [DetailSection] = []
    
    @Published var isIntroLoading: Bool = true
    @Published var isCommonLoading: Bool = true
    @Published var isImageLoading: Bool = true
    
    //@Published var isLoading: Bool = true
    @Published var errorMessage: String? = nil
    
    private var cancellable: Set<AnyCancellable> = []
    
   
    // MARK: - Function
    func fetchDetailInfo(contentId: String, contentType: String) async {
        isIntroLoading = true
        errorMessage = nil
        
        do {
            let result = try await NetworkManager.shared.getEateryIntroInfo(contentId: contentId, contentTypeId: contentType)
            self.detailIntro = result
            print("✅ DetailInfo: \(result)")
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ DetailViewModel: 에러 \(error.localizedDescription)")
        }
        
        isIntroLoading = false
    }
    
    
    /// contentId를 통해 음식점에 대한 공통된 데이터를 가져오는 메서드
    func fetchCommonIntroInfo(contentId: String) async {
        isCommonLoading = true
        errorMessage = nil
        
        do {
            let result = try await NetworkManager.shared.getEateryCommonInfo(contentId: contentId)
            self.commonIntro = result
            //print("✅ DetailCommonInfo: \(result)")
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ DetailViewModel: 에러 \(error.localizedDescription)")
        }
        
        isCommonLoading = false
    }
    
    
    /// 이미지 리스트를 가져오는 메서드
    func fetchDetailImageList(contentId: String) async {
        isImageLoading = true
        errorMessage = nil
        
        do {
            let result = try await NetworkManager.shared.getEateryDetailImage(contentId: contentId)
            self.detailImageList = result
            //print("✅ DetailImageList: \(result)")
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ DetailImageList: 에러 \(error.localizedDescription)")
        }
        
        isImageLoading = false
    }
    
    
    func clearDetailData() {
        self.detailIntro = []
        self.commonIntro = []
        self.detailImageList = []
    }
    
    
    /// IntroInfoItem → DetailSection 변환하는 메서드
//    func makeIntroSection() -> DetailSection? {
//        guard let item = detailIntro.first else { return nil }
//        
//        let convertedItems = [
//            ("대표 메뉴", item.firstmenu),
//            ("취급 메뉴", item.treatmenu),
//            ("문의 및 안내", item.infocenterfood),
//            ("영업 시간", item.opentimefood),
//            ("쉬는 날", item.restdatefood),
//            ("주차 시설", item.parkingfood),
//            ("포장 가능", item.packing)
//        ].map { DetailItemType.intro(title: $0.0, value: $0.1) }
//        
//        return DetailSection(type: .intro, item: convertedItems)
//    }
    
    
    /// CommonIntroItem → DetailSection 변환하는 메서드
//    func makeCommonSection() -> DetailSection? {
//        guard let item = commonIntro.first else { return nil }
//        
//        let convertedItems = [
//            ("주소", item.addr1),
//            ("소개", item.overview),
//            ("대표 이미지", item.firstimage),
//            ("가게 이름", item.title),
//            ("카테고리", item.cat3)
//        ].map { DetailItemType.common(title: $0.0, value: $0.1) }
//        
//        return DetailSection(type: .common, item: convertedItems)
//    }
    
    
    /// CommonIntroItem → DetailSection 변환하는 메서드
    func makeCommonSection() -> DetailSection? {
        guard let item = commonIntro.first else { return nil }
        
        let info = CommonInfo(
            title: item.title,
            cateogry: item.cat3,
            address: item.addr1,
            imageURL: item.firstimage
        )
        
        let singleItem: DetailItemType = DetailItemType.common(info: info)
        return DetailSection(type: .common, item: [singleItem])
    }
    
    
    /// IntroInfoItem → DetailSection 변환하는 메서드
    func makeIntroSection() -> DetailSection? {
        guard let item = detailIntro.first else { return nil }
        
        let info = IntroInfo(
            mainMenu: item.firstmenu,
            subMenu: item.treatmenu,
            inquiry: item.infocenterfood,
            openTime: item.opentimefood,
            restDay: item.restdatefood,
            parking: item.parkingfood,
            packing: item.packing
        )
        
        let singleItem: DetailItemType = DetailItemType.intro(info: info)
        return DetailSection(type: .intro, item: [singleItem])
    }

    
    
    /// DetailImageItem → DetailSection 변환하는 메서드
    func makeImageSection() -> DetailSection? {
        guard !detailImageList.isEmpty else { return nil }
        
        let convertedItems = detailImageList.map { item in
            let info = ImageListInfo(originalURL: item.originimgurl, imgName: item.imgname)
            return DetailItemType.image(info: info)
        }
        
        return DetailSection(type: .image, item: convertedItems)
    }
    
    
    /// 데이터 타입을 변환하는 메서드를 통합하는 메서드
    func makeAllSections() {
        var sections: [DetailSection] = []
        
        if let common = makeCommonSection() {
            sections.append(common)
        }
        
        if let intro = makeIntroSection() {
            sections.append(intro)
        }
        
        if let image = makeImageSection() {
            sections.append(image)
        }
        
        self.detailTotalModel = sections

    }    
}
