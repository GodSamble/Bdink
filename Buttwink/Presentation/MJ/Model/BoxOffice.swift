//
//  BoxOffice.swift
//  Buttwink
//
//  Created by 이명진 on 12/24/24.
//

import Foundation

//struct BoxOfficeResponse: Codable {
//    let boxOfficeResult: BoxOfficeResult
//}

struct BoxOfficeResult: Codable {
    let boxofficeType: String
    let showRange: String
    let dailyBoxOfficeList: [BoxOffice]
}

struct BoxOffice: Codable {
    let rank: String
    let movieName: String
    let openDate: String
    let audienceCount: String
    
    enum CodingKeys: String, CodingKey {
        case rank
        case movieName = "movieNm"
        case openDate = "openDt"
        case audienceCount = "audiCnt"
    }
}
