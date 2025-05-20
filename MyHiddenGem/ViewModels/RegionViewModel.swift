//
//  RegionViewModel.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/20/25.
//

import Foundation
import Combine


@MainActor
final class RegionViewModel {
    
    // MARK: - Variable
    @Published var regionList: [RegionCodeModel] = []
    
    @Published var errorMessagee: String? = nil
    @Published var isLoading: Bool = true
    
    
    
    // MARK: - Function
    /// 지역코드 정보를 받아오는 메서드 
    func fetchRegionCode() async {
        errorMessagee = nil
        isLoading = true
        
        do {
            let result = try await NetworkManager.shared.getRegionCode()
            self.regionList = result
            print("✅ RegionViewModel: \(result.count)개 지역코드 로딩")
        } catch {
            self.errorMessagee = error.localizedDescription
            print("❌ RegionViewModel: 에러 \(error.localizedDescription)")
        }
        isLoading = false
    }
    
}
