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
    
    func fetchYoutubeVideoList(id: String, part: String) async throws -> [Entity_YoutubeData] {
        let dto = try await networkService.fetchYoutubeData(id: id, part: part)
        return mapper.transform(dto)
    }
}
