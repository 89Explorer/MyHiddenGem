//
//  NetworkManager.swift
//  MyHiddenGem
//
//  Created by 권정근 on 4/24/25.
//

import Foundation


// MARK: - Constants
struct Constants {
    
    static let api_key = Bundle.main.infoDictionary?["API_Key"] as! String
    static let baseURLString: String = "https://apis.data.go.kr/B551011/KorService1"
    static let latestbaseURLString: String = "https://apis.data.go.kr/B551011/KorService2"
    
}



// MARK: - API Caller
class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    /// 📍 음식점 카테고리를 받아오는 함수
    func getStoreCategories() async throws -> [StoreCategory] {
        var components = URLComponents(string: "\(Constants.baseURLString)/categoryCode1")
        
        components?.queryItems = [
            URLQueryItem(name: "serviceKey", value: Constants.api_key),
            URLQueryItem(name: "numOfRows", value: "10"),
            URLQueryItem(name: "pageNo", value: "1"),
            URLQueryItem(name: "MobileOS", value: "ETC"),
            URLQueryItem(name: "MobileApp", value: "AppTest"),
            URLQueryItem(name: "contentTypeId", value: "39"),
            URLQueryItem(name: "cat1", value: "A05"),
            URLQueryItem(name: "cat2", value: "A0502"),
            URLQueryItem(name: "_type", value: "json")
        ]
        
        // URL 인코딩 오류 방지
        if let encodedQuery = components?.percentEncodedQuery?.replacingOccurrences(of: "%25", with: "%") {
            components?.percentEncodedQuery = encodedQuery
        }
        
        guard let url = components?.url else {
            print("❌ URL 생성 실패: \(String(describing: components?.string))")
            throw URLError(.badURL)
        }
        
        //print("📡 호출할 URL: \(url.absoluteString)")
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // 1️⃣ 상태 코드 디버깅
            if let httpResponse = response as? HTTPURLResponse {
                print("🔹 상태 코드: \(httpResponse.statusCode)")
            }
            
            let decoded = try JSONDecoder().decode(CategoryResponse.self, from: data)
            //print("✅ 디코딩 성공, 항목 개수: \(decoded.response.body.items.item.count)")
            return decoded.response.body.items.item
            
        } catch let decodingError as DecodingError {
            print("❌ 디버깅 오류: \(decodingError)")
            throw decodingError
            
        } catch {
            print("❌ 네트워크 요청 또는 기타 오류: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// 📍 음식점 리스트 받아오는 함수 (1번에 20개씩)
    func getEateryLists(pageNo: String? = nil, areaCode: Int? = nil, cat1: String? = "A05", cat2: String? = "A0502", cat3: String? = nil) async throws -> [EateryItem] {
        var components = URLComponents(string: "\(Constants.latestbaseURLString)/areaBasedList2")
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "serviceKey", value: Constants.api_key),
            URLQueryItem(name: "numOfRows", value: "20"),
            URLQueryItem(name: "pageNo", value: pageNo),
            URLQueryItem(name: "MobileOS", value: "ETC"),
            URLQueryItem(name: "MobileApp", value: "AppTest"),
            URLQueryItem(name: "_type", value: "json"),
            URLQueryItem(name: "arrange", value: "R"),
            URLQueryItem(name: "contentTypeId", value: "39"),
            URLQueryItem(name: "cat1", value: cat1),
            URLQueryItem(name: "cat2", value: cat2),
            URLQueryItem(name: "cat3", value: cat3),
            
        ]
        
        if let areaCode = areaCode {
            queryItems.append(URLQueryItem(name: "areaCode", value: "\(areaCode)"))
        }
        
        components?.queryItems = queryItems
        
        if let encodedQuery = components?.percentEncodedQuery?.replacingOccurrences(of: "%25", with: "%") {
            components?.percentEncodedQuery = encodedQuery
        }
        
        
        // 👉 URL 생성
        guard let url = components?.url else {
            print("❌ URL 생성 실패: \(String(describing: components?.string))")
            throw URLError(.badURL)
        }
        
        //print("📡 호출할 URL: \(url.absoluteString)")
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("🔹 상태 코드: \(httpResponse.statusCode)")
            }
            
            /*
             // 👉 받은 데이터를 문자열로 출력
             if let rawString = String(data: data, encoding: .utf8) {
             print("📦 받은 응답 본문:\n\(rawString)")
             }
             */
            
            let decoded = try JSONDecoder().decode(EateryWelcome.self, from: data)
            // print("✅ 디코딩 성공, 항목 개수: \(decoded.response.body.items.item.count)")
            return decoded.response.body.items.item
            
        } catch let decodingError as DecodingError {
            print("❌ 디코딩 오류: \(decodingError)")
            throw decodingError
            
        } catch {
            print("❌ 네트워크 요청 오류: \(error.localizedDescription)")
            throw error
        }
    }
    
    
    /// 지역 코드 정보를 받아오는 메서드
    func getRegionCode() async throws -> [RegionCodeModel] {
        
        var components = URLComponents(string: "\(Constants.latestbaseURLString)/areaCode2")
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "serviceKey", value: Constants.api_key),
            URLQueryItem(name: "numOfRows", value: "20"),
            URLQueryItem(name: "pageNo", value: "1"),
            URLQueryItem(name: "MobileOS", value: "ETC"),
            URLQueryItem(name: "MobileApp", value: "AppTest"),
            URLQueryItem(name: "_type", value: "json")
        ]
        
        components?.queryItems = queryItems
        
        if let encodedQuery = components?.percentEncodedQuery?.replacingOccurrences(of: "%25", with: "%") {
            components?.percentEncodedQuery = encodedQuery
        }
        
        guard let url = components?.url else {
            print("❌ URL 생성 실패: \(String(describing: components?.string))")
            throw URLError(.badURL)
        }
        
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("🌐 지역 코드 상태 코드: \(httpResponse.statusCode)")
            }
            
            let decoded = try JSONDecoder().decode(RegionWelcome.self, from: data)
            return decoded.response.body.items.item
        } catch let decodingError as DecodingError {
            print("❌ 지역 코드 디코딩 오류: \(decodingError)")
            throw decodingError
        } catch {
            print("❌ 지역 코드 네트워크 요청 오류: \(error.localizedDescription)")
            throw error
        }
    }
}


