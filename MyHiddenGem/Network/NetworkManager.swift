//
//  NetworkManager.swift
//  MyHiddenGem
//
//  Created by 권정근 on 4/24/25.
//

import Foundation


// MARK: - API Caller
class NetworkManager {
    
    static let shared: NetworkManager = NetworkManager()
    
    
    func getData() {
        let categoryURL = "https://apis.data.go.kr/B551011/KorService1/categoryCode1?serviceKey=jlK%2B0ig7iLAbdOuTJsnkp6n0RdeEMtGKsw53jEMbKm3PcB7NFTSeUrnXixogiuvNtHQXeqxgV88buRZvTjG73w%3D%3D&numOfRows=10&pageNo=1&MobileOS=ETC&MobileApp=AppTest&contentTypeId=39&cat1=A05&cat2=A0502&_type=json"
        
        guard let url = URL(string: categoryURL) else {
            print("❌ URL 생성 실패")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ 에러 발생: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("❌ 데이터가 없습니다.")
                return
            }

            do {
                let decoded = try JSONDecoder().decode(CategoryResponse.self, from: data)
                let categories: [StoreCategory] = decoded.response.body.items.item
                print("✅ 필요한 카테고리만 출력:")
                categories.forEach { print("- \( $0.name ) (\( $0.code ))") }
            } catch {
                print("❌ 디코딩 실패: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

}
