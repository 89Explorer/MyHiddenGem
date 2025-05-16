//
//  EateryViewModel.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/14/25.
//

import Foundation
import Combine


@MainActor
class EateryViewModel: ObservableObject {
    
    // MARK: - Variable
    @Published var eateries: [EateryItem] = []
    @Published var gyeonggiEateries: [EateryItem] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading = true
    
    // MARK: - Function
    func fetchEateries() async {
        errorMessage = nil
        isLoading = true
        
        // ✅ async let → 병렬 실행
        async let nationwideTask: [EateryItem] = NetworkManager.shared.getEateryLists()
        async let gyeonggiTask: [EateryItem] = NetworkManager.shared.getEateryLists(areaCode: 1)
        
        do {
            let (nationwide, gyeonggi) = try await (nationwideTask, gyeonggiTask)
            self.eateries = nationwide
            self.gyeonggiEateries = gyeonggi
            print("✅ ViewModel: 전국 \(nationwide.count)개, 경기 \(gyeonggi.count)개 음식점 로딩")

        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ ViewModel 에러: \(error.localizedDescription)")
        }
        
        self.isLoading = false // 성공, 실패 모두
    }
}
