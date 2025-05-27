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
    
}
