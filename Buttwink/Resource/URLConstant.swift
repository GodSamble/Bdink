//
//  URLConstant.swift
//  Buttwink
//
//  Created by 고영민 on 12/4/24.
//

import Foundation

struct URLConstant {

    // MARK: - Base URL
    
    static let baseURL = (Bundle.main.infoDictionary?["BASE_URL"] as! String).replacingOccurrences(of: " ", with: "")

    // MARK: - Route
    
//    static let feed = "/feed"
//    static let goal = "/goal"
//    static let feedLike = "/feedLike"
//    static let user = "/user"
//    static let recommend = "/recommend"
}
