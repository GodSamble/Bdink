//
//  TabBarItem.swift
//  Buttwink
//
//  Created by 고영민 on 11/25/24.
//

import DesignSystem
import UIKit

enum TabBarItem: CaseIterable {
    case lecture
    case search
    case premium
    case mypage
    
    var title: String {
        switch self {
        case .lecture:       return "강의"
        case .search:        return "검색"
        case .premium:       return "프리미엄"
        case .mypage:        return "마이페이지"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .lecture:       return .Icon.feed
        case .search:        return .Icon.feed
        case .premium:       return .Icon.mypage
        case .mypage:        return .Icon.mypage
        }
    }
    
    var rootViewController: UIViewController {
        switch self {
        case .lecture: return DIContainer.shared.container.resolve(MypageViewController.self)!
        case .search: return ViewController()
        case .premium:       return MovieViewController()
        case .mypage:        return ViewController()
        }
    }
}
