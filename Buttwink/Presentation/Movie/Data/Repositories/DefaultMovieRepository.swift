//
//  DefaultMovieRepository.swift
//  Buttwink
//
//  Created by 이지훈 on 12/25/24.
//

import Foundation

final class DefaultMovieRepository: MovieRepository {
    private let networkService: BoxOfficeNetworkService
    private let mapper: BoxOfficeMapper
    
    init(networkService: BoxOfficeNetworkService, mapper: BoxOfficeMapper) {
        self.networkService = networkService
        self.mapper = mapper
    }
    
    func fetchDailyBoxOffice(date: Date) async throws -> [Movie] {
        let dto = try await networkService.fetchDailyBoxOffice(date: date)
        return mapper.transform(dto)
    }
}
