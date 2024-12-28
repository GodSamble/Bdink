//
//  BoxOfficeMapper.swift
//  Buttwink
//
//  Created by 이지훈 on 12/25/24.
//

import Foundation

protocol BoxOfficeMapper {
    func transform(_ dto: BoxOfficeDTO) -> [Movie]
}

final class DefaultBoxOfficeMapper: BoxOfficeMapper {
    func transform(_ dto: BoxOfficeDTO) -> [Movie] {
        return dto.boxOfficeResult.dailyBoxOfficeList.map { dailyBoxOffice in
            Movie(
                rank: dailyBoxOffice.rank,
                title: dailyBoxOffice.movieNm,
                audienceCount: Int(dailyBoxOffice.audiCnt) ?? 0,
                releaseDate: DateFormatter.yyyyMMdd.date(from: dailyBoxOffice.openDt) ?? Date()
            )
        }
    }
}

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    static let displayDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
}

extension NumberFormatter {
    static let decimal: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter
    }()
}
