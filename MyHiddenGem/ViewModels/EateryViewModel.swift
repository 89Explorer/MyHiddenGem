//
//  EateryViewModel.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/14/25.
//

import Foundation
import Combine


class EateryViewModel: ObservableObject {
    
    // MARK: - Variable
    @Published var eateries: [EateryItem] = []
    @Published var errorMessage: String? = nil
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    // MARK: - Function
    func fetchEateries() async {
        errorMessage = nil
        
        do {
            let result = try await NetworkManager.shared.getEateryLists()
            self.eateries = result
            print("✅ ViewModel: \(result.count)개 음식점 로딩")
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ ")
        }
    }
    
}
