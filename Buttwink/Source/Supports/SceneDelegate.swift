//
//  SceneDelegate.swift
//  Buttwink
//
//  Created by 고영민 on 11/10/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        // Set TabBarController as the root
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
        
        window.makeKeyAndVisible()
    }
}
