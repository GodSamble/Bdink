//
//  MovieRepository.swift
//  Buttwink
//
//  Created by 이지훈 on 12/25/24.
//

import Foundation

protocol MovieRepository {
    func fetchDailyBoxOffice(date: Date) async throws -> [Movie]
}
