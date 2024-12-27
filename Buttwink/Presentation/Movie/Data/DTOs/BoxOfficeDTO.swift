//
//  BoxOfficeDTO.swift
//  Buttwink
//
//  Created by 이지훈 on 12/25/24.
//

import Foundation

struct BoxOfficeDTO: Codable {
    let boxOfficeResult: BoxOfficeResultDTO
    
    struct BoxOfficeResultDTO: Codable {
        let dailyBoxOfficeList: [DailyBoxOfficeDTO]
    }
    
    struct DailyBoxOfficeDTO: Codable {
        let rank: String
        let movieNm: String
        let audiCnt: String
        let openDt: String
    }
}
