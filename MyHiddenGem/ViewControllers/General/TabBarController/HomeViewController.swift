//
//  HomeViewController.swift
//  MyHiddenGem
//
//  Created by 권정근 on 4/23/25.
//

import UIKit

class HomeViewController: UIViewController {

    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupHeaderView()
        setupHeaderButtons()
    }
    
    
}


// MARK: - Extension: 홈화면 상단 View
extension HomeViewController {
    
    /// 홈 화면 상단 뷰 설정
    func setupHeaderView() {
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "Must-Go?"
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


