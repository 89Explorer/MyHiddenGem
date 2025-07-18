//
//  MaintTabBarController.swift
//  MyHiddenGem
//
//  Created by 권정근 on 4/23/25.
//

import UIKit

class MaintTabBarController: UITabBarController {

    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTabBar()
    }
    
}


// MARK: - Extension: - 기본 설정
extension MaintTabBarController {
    
    private func setupTabBar() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let locationVC = UINavigationController(rootViewController: LocationViewController(mapX: 37.5665, mapY: 126.9780))
        let addFeedVC = UINavigationController(rootViewController: AddFeedViewController())
        let noteVC = UINavigationController(rootViewController: NoteViewController())
        
        homeVC.tabBarItem.image = UIImage(systemName: "house.circle")
        homeVC.tabBarItem.selectedImage = UIImage(systemName: "house.circle.fill")
        
        locationVC.tabBarItem.image = UIImage(systemName: "mappin.and.ellipse.circle")
        locationVC.tabBarItem.selectedImage = UIImage(systemName: "mappin.and.ellipse.circle.fill")
        
        addFeedVC.tabBarItem.image = UIImage(systemName: "plus.circle")
        addFeedVC.tabBarItem.selectedImage = UIImage(systemName: "plus.circle.fill")
        
        noteVC.tabBarItem.image = UIImage(systemName: "document.circle")
        noteVC.tabBarItem.selectedImage = UIImage(systemName: "document.circle.fill")
        
        tabBar.tintColor = .label
        tabBar.backgroundColor = .systemBackground
        
        setViewControllers([homeVC, locationVC, noteVC], animated: true)
    }
}

