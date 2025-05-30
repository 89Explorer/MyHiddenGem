//
//  SceneDelegate.swift
//  MyHiddenGem
//
//  Created by 권정근 on 4/23/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = MaintTabBarController()
        window?.makeKeyAndVisible()
    }
}

