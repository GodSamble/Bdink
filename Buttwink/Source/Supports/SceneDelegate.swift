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
        
        // 1.
        guard let windowScene = (scene as? UIWindowScene) else { return }
        // 2.
        self.window = UIWindow(windowScene: windowScene)
        // 3.
        let navigationController = UINavigationController(rootViewController: ViewController())
        self.window?.rootViewController = navigationController
        // 4.
        self.window?.makeKeyAndVisible()
    }
}
