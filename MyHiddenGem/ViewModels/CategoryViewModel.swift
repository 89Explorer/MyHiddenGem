//
//  CategoryViewModel.swift
//  MyHiddenGem
//
//  Created by 권정근 on 4/25/25.
//

import Foundation
import Combine


class CategoryViewModel: ObservableObject {
    
    @Published var categories: [StoreCategory] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    func fetchCategories() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await NetworkManager.shared.getStoreCategories()
            self.categories = result
            print("✅ ViewModel: \(result.count)개 카테고리 로딩")
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ ViewModel: 에러 \(error.localizedDescription)")
        }
        
        isLoading = false 
    }
}
