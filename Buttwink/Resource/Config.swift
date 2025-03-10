//
//  Config.swift
//  Buttwink
//
//  Created by 고영민 on 12/4/24.
//

import Foundation

enum Config {
    
    static let apiKey: String = "847ea8be660312dc390395b996b40d8c"
    
    enum Keys {
        enum Plist {
            static let baseURL = "BASE_URL"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist cannot found.")
        }
        return dict
    }()
}

extension Config {
    
    static let baseURL: String = {
        guard let key = Config.infoDictionary[Keys.Plist.baseURL] as? String else {
            fatalError("Base URL is not set in plist for this configuration.")
        }
        return key
    }()
}
