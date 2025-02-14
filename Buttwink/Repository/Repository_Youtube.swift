//
//  Repository_Youtube.swift
//  Buttwink
//
//  Created by 고영민 on 1/23/25.
//

import Foundation

final class Repository_Youtube: RepositoryInterface_Youtube {
    
    private let networkService: YoutubeDataService // 프로토콜 가져다 끌어옴
    private let mapper: Mappers_YoutubeData // 프로토콜 가져다 끌어옴
    
    init(networkService: YoutubeDataService, mapper: Mappers_YoutubeData) {
        self.networkService = networkService
        self.mapper = mapper
    }
    
    func fetchYoutubeSearch(query: String, maxResults: Int) async throws -> [Entity_YoutubeData] {
        let dto = try await networkService.fetchYoutubeSearch(query: query, maxResults: maxResults)
        return mapper.transform(dto)
    }
}
