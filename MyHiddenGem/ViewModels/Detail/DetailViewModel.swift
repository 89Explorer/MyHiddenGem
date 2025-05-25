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
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellable: Set<AnyCancellable> = []
    
    
    
    // MARK: - Function
    func fetchDetailInfo(contentId: String, contentType: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await NetworkManager.shared.getEateryIntroInfo(contentId: contentId, contentTypeId: contentType)
            self.detailIntro = result
            print("✅ DetailInfo: \(result)")
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ DetailViewModel: 에러 \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    
    /// contentId를 통해 음식점에 대한 공통된 데이터를 가져오는 메서드
    func fetchCommonIntroInfo(contentId: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await NetworkManager.shared.getEateryCommonInfo(contentId: contentId)
            self.commonIntro = result
            print("✅ DetailCommonInfo: \(result)")
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ DetailViewModel: 에러 \(error.localizedDescription)")
        }
        
        isLoading = false
    }
}
