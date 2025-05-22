//
//  CategoryViewModel.swift
//  MyHiddenGem
//
//  Created by 권정근 on 4/25/25.
//

import Foundation
import Combine


@MainActor
class CategoryViewModel: ObservableObject {
    
    // MARK: - Variable
    @Published var categories: [StoreCategory] = []
    @Published var emojiCategories: [CategoryEmogi] = []
    @Published var eateryFromCategory: [EateryItem] = []
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Function
    
    /// 음식점 카테고리 정보를 받아오는 메서드
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
    
    
    /// 카테고리에 이모지를 추가하여 새 배열 생성 
    func updateCategories(){
        
        let emojiMap: [String: String] = [
            "한식": "🍚",
            "서양식": "🥩",
            "일식": "🍣",
            "중식": "🍜",
            "이색음식점": "🍤",
            "카페/전통찻집": "☕️",
            //"클럽": "🎧"
        ]
        
        // "클럽" 카테고리는 제외하고 저장
        let filteredCategories = categories.filter { category in
            category.name != "클럽"
        }
        
        self.emojiCategories = filteredCategories.map { category in
            let name = category.name
            let icon = emojiMap[name] ?? "🍽️"
            let code = category.code
            return CategoryEmogi(code: code, name: name, icon: icon)
        }
    }
    
    
    
    /// 카테고리에 맞는 음식점 데이터 가져오기
    func fetchEateryFromCategory(pageNo: String? = nil, cat3: String? = nil) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await NetworkManager.shared.getEateryLists(pageNo: pageNo, cat3: cat3)
            //self.eateryFromCategory = result
            
            self.eateryFromCategory.append(contentsOf: result)
            print("✅ Category에서 가져온 음식점 갯수: \(result.count)개")
        } catch {
            self.errorMessage = error.localizedDescription
            print("✅ CategoryViewModel: 에러 \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    
    /// eateryFromCategory 배열 초기화
    func clearEateryData() {
        self.eateryFromCategory = []
    }

}
