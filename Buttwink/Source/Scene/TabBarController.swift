//
//  TabBarController.swift
//  Buttwink
//
//  Created by 고영민 on 11/11/24.
//

import DesignSystem
import UIKit


final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        setTabBar()
    }
    
    private func setViewControllers() {
        let viewControllers = TabBarItem.allCases.map { item -> UINavigationController in
                 let naviController = UINavigationController(rootViewController: item.rootViewController)
                 naviController.tabBarItem = UITabBarItem(
                     title: item.title,
                     image: item.image,
                     tag: TabBarItem.allCases.firstIndex(of: item) ?? 0
                 )
                 return naviController
             }
             self.viewControllers = viewControllers
    }
    
    private func setTabBar() {
        tabBar.tintColor = .buttwink_green700
        tabBar.unselectedItemTintColor = .buttwink_gray900
        tabBar.backgroundColor = .buttwink_gray50
    }
}
