//
//  BoxOffice.swift
//  Buttwink
//
//  Created by 이명진 on 12/24/24.
//

import Foundation

struct BoxOffice: Codable {
    let rank: String       // 순위
    let movieName: String  // 영화명
    let openDate: String   // 개봉일
    let audienceCount: String // 해당일 관객수
    
    enum CodingKeys: String, CodingKey {
        case rank
        case movieName = "movieNm"
        case openDate = "openDt"
        case audienceCount = "audiCnt"
    }
}
