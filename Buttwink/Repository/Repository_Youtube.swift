//
//  Repository_Youtube.swift
//  Buttwink
//
//  Created by 고영민 on 1/23/25.
//

import Foundation

final class Repository_Youtube: RepositoryInterface_Youtube {
    
    private let networkService: YoutubeDataService
    private let mapper: Mappers_YoutubeData

    init(networkService: YoutubeDataService, mapper: Mappers_YoutubeData) {
        self.networkService = networkService
        self.mapper = mapper
    }

    
    func fetchYoutubeSearch(query: String, maxResults: Int) async throws -> (
        search: Entity_YoutubeData,
        video: Entity_YoutubeVideoData,
        channel: Entity_YoutubeChannelData
    ) {
        let searchDto = try await networkService.fetchYoutubeSearch(query: query, maxResults: maxResults)
        
        async let videoDto: DTO_YoutubeVideoData = networkService.fetchYoutubeData(
            ids: searchDto.items.map { $0.id.videoID },
            part: "snippet,statistics"
        )
        
        async let channelDto = networkService.fetchYoutubeChannel(
            ids: searchDto.items.map { $0.snippet.channelId },
            part: "snippet"
        )

        let (video, channel) = try await (videoDto, channelDto)

        return mapper.transform(searchDto: searchDto, videoDto: video, channelDto: channel)
    }

}
