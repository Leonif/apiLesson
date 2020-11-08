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
            window?.rootViewController = FriendListViewController()
            window?.makeKeyAndVisible()
        } else {
            let vc = WKAutorizationViewController()
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
            vc.autorised = { [unowned self] success in
                if success {
                    window?.rootViewController = FriendListViewController()
                    window?.makeKeyAndVisible()
                }
            }
        }
    }
}

