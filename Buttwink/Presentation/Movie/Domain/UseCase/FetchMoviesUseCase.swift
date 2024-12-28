//
//  FetchMoviesUseCase.swift
//  Buttwink
//
//  Created by 이지훈 on 12/25/24.
//

import Foundation

protocol FetchMoviesUseCase {
    func execute(date: Date) async throws -> [Movie]
}

final class DefaultFetchMoviesUseCase: FetchMoviesUseCase {
    private let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func execute(date: Date) async throws -> [Movie] {
        return try await movieRepository.fetchDailyBoxOffice(date: date)
    }
}
