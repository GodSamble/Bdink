//
//  BoxOffice.swift
//  Buttwink
//
//  Created by 이명진 on 12/24/24.
//

import Foundation

// 최상위 응답 구조체
struct BoxOfficeResponse: Codable {
    let boxOfficeResult: BoxOfficeResult
}

// BoxOfficeResult 구조체
struct BoxOfficeResult: Codable {
    let boxofficeType: String          // 박스오피스 타입
    let showRange: String              // 조회 날짜 범위
    let dailyBoxOfficeList: [BoxOffice] // 일별 박스오피스 목록
}

// BoxOffice 구조체 (기존 제공된 코드 수정)
struct BoxOffice: Codable {
    let rank: String                   // 순위
    let movieName: String              // 영화명
    let openDate: String               // 개봉일
    let audienceCount: String          // 해당일 관객수
    
    enum CodingKeys: String, CodingKey {
        case rank
        case movieName = "movieNm"
        case openDate = "openDt"
        case audienceCount = "audiCnt"
    }
}
