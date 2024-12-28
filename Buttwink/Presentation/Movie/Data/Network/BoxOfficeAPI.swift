//
//  BoxOfficeAPI.swift
//  Buttwink
//
//  Created by 이지훈 on 12/25/24.
//

import Foundation
import Moya

enum BoxOfficeAPI {
    case dailyBoxOffice(date: String)
}

extension BoxOfficeAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice")!
    }
    
    var path: String {
        switch self {
        case .dailyBoxOffice:
            return "/searchDailyBoxOfficeList.json"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .dailyBoxOffice(let date):
            return .requestParameters(
                parameters: [
                    "key": "63adcda43f0b97ae5d966b40878b62fb",
                    "targetDt": date
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
