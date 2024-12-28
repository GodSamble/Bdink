////
////  BoxOfficeTargetType.swift
////  Buttwink
////
////  Created by 이지훈 on 12/22/24.
////
//
//import Foundation
//import RxSwift
//import RxCocoa
//import Moya
//
//protocol BoxOfficeTargetType: TargetType {
//    var apiKey: String { get }
//}
//
//extension BoxOfficeTargetType {
//    var baseURL: URL {
//        return URL(string: "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice")!
//    }
//    
//    var apiKey: String {
//        return "63adcda43f0b97ae5d966b40878b62fb"
//    }
//    
//    var headers: [String: String]? {
//        return ["Content-Type": "application/json"]
//    }
//    
//    var sampleData: Data {
//        return Data()
//    }
//}
//
//enum BoxOfficeAPI {
//    case dailyBoxOffice(date: String)
//}
//
//extension BoxOfficeAPI: BoxOfficeTargetType {
//    var path: String {
//        switch self {
//        case .dailyBoxOffice:
//            return "/searchDailyBoxOfficeList.json"
//        }
//    }
//    
//    var method: Moya.Method {
//        return .get
//    }
//    
//    var task: Moya.Task {
//        switch self {
//        case .dailyBoxOffice(let date):
//            let parameters: [String: Any] = [
//                "key": apiKey,
//                "targetDt": date
//            ]
//            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
//        }
//    }
//}
