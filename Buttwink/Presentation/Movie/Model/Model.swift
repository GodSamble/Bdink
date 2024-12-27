//
//  Model.swift
//  Buttwink
//
//  Created by 이지훈 on 12/22/24.
//

import Foundation

struct MovieModel: Hashable {
    let id: String
    let movieName: String
    let audienceCount: String
    let openDate: String
}

struct BoxOfficeResponse: Codable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Codable {
    let dailyBoxOfficeList: [DailyBoxOffice]
}

struct DailyBoxOffice: Codable {
    let rank: String
    let movieNm: String
    let audiCnt: String
    let openDt: String
}
