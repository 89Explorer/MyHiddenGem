//
//  HomeViewController.swift
//  MyHiddenGem
//
//  Created by 권정근 on 4/23/25.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    
    // MARK: - Variable
    private let categoriesViewModel: CategoryViewModel = CategoryViewModel()
    
    private var recommendationCollectionView: UICollectionView!
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupHeaderView(with: "투데이")
        setupHeaderButtons()
        fetchCategories()
        
        
        Task {
            do {
                let places = try await NetworkManager.shared.getEateryLists()
                print("📍 불러온 장소 수: \(places.count)")
                
                for place in places {
                    print("🗺️ \(place.title) - \(place.addr1)")
                }
            } catch {
                print("❌ 오류 발생: \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - Functions
    private func fetchCategories() {
        
        Task {
            await categoriesViewModel.fetchCategories()
            print("📋 카테고리 목록:")
            categoriesViewModel.categories.forEach { print("- \($0.name)") }
            // 이후 collectionView.reloadData() 같은 뷰 업데이트 호출
        }
    }
    
    
}


// MARK: - Extension: 홈화면 상단 View
extension HomeViewController {
    
    /// 홈 화면 상단 뷰 설정
    func setupHeaderView(with title: String) {
        let titleLabel: UILabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .label
        
        let leftBarButton = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    
    /// 홈 화면 상단 오른쪽 버튼 설정 (검색, 알람)
    func setupHeaderButtons() {
        let searchButton = UIButton(type: .system)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .label
        searchButton.addTarget(self, action: #selector(didTappedSearchButton), for: .touchUpInside)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        
        let alarmButton = UIButton(type: .system)
        alarmButton.setImage(UIImage(systemName: "bell"), for: .normal)
        alarmButton.tintColor = .label
        alarmButton.addTarget(self, action: #selector(didTappedAlarmButton), for: .touchUpInside)
        
        let alarmBarButton = UIBarButtonItem(customView: alarmButton)
        
        navigationItem.rightBarButtonItems = [alarmBarButton, searchBarButton]
    }
    
    
    // MARK: - Actions
    
    /// 검색 버튼을 누르면 동작하는 액션 메서드
    @objc private func didTappedSearchButton() {
        print("검색 버튼을 눌름")
    }
    
    
    /// 알람 버튼을 누르면 동작하는 액션 메서드
    @objc private func didTappedAlarmButton() {
        print("알람 버튼을 눌름")
    }
}


