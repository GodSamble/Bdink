//
//  Usecase_Youtube.swift
//  Buttwink
//
//  Created by 고영민 on 1/23/25.
//

import Foundation

protocol FetchUnifiedYoutubeDataUseCase {
    func execute(query: String, maxResults: Int, videoPart: String, channelPart: String, ids: [String]) async throws -> [UnifiedYoutubeEntity]
}

final class FetchUnifiedYoutubeDataUseCaseImpl: FetchUnifiedYoutubeDataUseCase {
    
    private let repositoryInterface_Youtube: RepositoryInterface_Youtube
    
    init(repositoryInterface_Youtube: RepositoryInterface_Youtube) {
        self.repositoryInterface_Youtube = repositoryInterface_Youtube
        
    }
    
    func execute(query: String, maxResults: Int, videoPart: String, channelPart: String, ids: [String]) async throws -> [UnifiedYoutubeEntity] {
        let entityYoutubeData = try await repositoryInterface_Youtube.fetchYoutubeSearch(query: query, maxResults: maxResults)
        
        return [
            UnifiedYoutubeEntity(
                viewCount: entityYoutubeData.video.viewCount,  // 🔥 올바른 필드로 변경
                channelThumbnailUrl: entityYoutubeData.channel.channelThumbnailUrl,
                videoId: entityYoutubeData.search.videoId,
                title: entityYoutubeData.search.title,
                thumbnailUrl: entityYoutubeData.search.thumbnailUrl,
                channelId: entityYoutubeData.search.channelId,
                channelName: entityYoutubeData.search.channelName
            )
        ]
    }
}
