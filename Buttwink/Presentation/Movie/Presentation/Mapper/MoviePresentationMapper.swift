//
//  MoviePresentationMapper.swift
//  Buttwink
//
//  Created by 이지훈 on 12/25/24.
//

import Foundation

protocol MoviePresentationMapper {
    func transform(_ domain: [Movie]) -> [MoviePresentationModel]
}

final class DefaultMoviePresentationMapper: MoviePresentationMapper {
    func transform(_ domain: [Movie]) -> [MoviePresentationModel] {
        return domain.map { movie in
            MoviePresentationModel(
                id: movie.rank,
                title: movie.title,
                audienceCount: NumberFormatter.decimal.string(from: NSNumber(value: movie.audienceCount)) ?? "0",
                releaseDate: DateFormatter.displayDate.string(from: movie.releaseDate)
            )
        }
    }
}
