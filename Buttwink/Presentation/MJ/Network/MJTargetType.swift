//
//  MJTargetType.swift
//  Buttwink
//
//  Created by 이명진 on 12/23/24.
//

import Moya

import UIKit

enum MJTargetType {
    case getMovieData(date: String)
}

extension MJTargetType: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice") else {
            fatalError("baseURL could not be configured")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getMovieData:
            return "/searchDailyBoxOfficeList.json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMovieData:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMovieData(let date):
            return .requestParameters(
                parameters: ["key": Config.apiKey, "targetDt": date],
                encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String: String]? {
        // GET 요청에는 특별히 필요하지 않으므로 제거
        return nil
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
