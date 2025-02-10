//
//  Usecase_Youtube.swift
//  Buttwink
//
//  Created by 고영민 on 1/23/25.
//

import Foundation

protocol YoutubeVideosUseCase {
    func execute(id:String, part: String) async throws -> [Entity_YoutubeData]
}

final class FetchYoutubeVideosUseCase: YoutubeVideosUseCase {
    
    private let repositoryInterface_Youtube: RepositoryInterface_Youtube
    
    init(repositoryInterface_Youtube: RepositoryInterface_Youtube) {
        self.repositoryInterface_Youtube = repositoryInterface_Youtube
    }
    
    func execute(id: String, part: String) async throws -> [Entity_YoutubeData] {
        return try await repositoryInterface_Youtube.fetchYoutubeVideoList(id: id, part: part)
    }
}
