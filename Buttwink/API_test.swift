//
//  TestAPI.swift
//  Buttwink
//
//  Created by 고영민 on 12/4/24.
//

import Foundation
import Moya

enum TestAPI {
    case getWeatherTest(lat: Double, lon: Double)
}

extension TestAPI: TargetType {
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }

    var path: String {
        switch self {
        case .getWeatherTest:
            return "/weather" // Update this path as needed
        }
    }

    var method: Moya.Method {
        switch self {
        case .getWeatherTest:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getWeatherTest(let lat, let lon):
            return .requestParameters(
                parameters: [
                    "lat": lat,
                    "lon": lon,
                    "appid": "2750b5cd65bc1cc2e44cad5ea05e4bcd" // 유효한 API Key를 입력하세요.
                ],
                encoding: URLEncoding.queryString
            )
        }
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json" // Set headers as you did with Alamofire
        ]
    }
}
