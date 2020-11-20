//
//  SceneDelegate.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 24.09.2020.
//

import UIKit
import SwiftKeychainWrapper

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        if !ApiManager.session.token.isEmpty, !ApiManager.session.userId.isEmpty {
            window?.rootViewController = createMainScreen()
            window?.makeKeyAndVisible()
        } else {
            let vc = WKAutorizationViewController()
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
            vc.autorised = { [unowned self] success in
                if success {
                    window?.rootViewController = createMainScreen()
                    window?.makeKeyAndVisible()
                }
            }
        }
    }
    
    
    private func createMainScreen() -> UITabBarController {
        let tabBar = UITabBarController()
        
        let friends = FriendListViewController()
        friends.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        let feed = NewsViewController()
        feed.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)
        
        tabBar.viewControllers = [friends, feed]
        
        return tabBar
    }
}

