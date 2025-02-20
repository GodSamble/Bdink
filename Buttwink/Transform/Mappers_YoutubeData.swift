//
//  Mappers_YoutubeData.swift
//  Buttwink
//
//  Created by 고영민 on 1/23/25.
//

import Foundation

protocol Mappers_YoutubeData {
    func transform(searchDto: DTO_SearchData, videoDto: DTO_YoutubeVideoData, channelDto: DTO_YoutubeChannelData) -> (
        search: Entity_YoutubeData,
        video: Entity_YoutubeVideoData,
        channel: Entity_YoutubeChannelData
    )
    
}

final class Mappers_YoutubeDataDefault: Mappers_YoutubeData {
    func transform(searchDto: DTO_SearchData, videoDto: DTO_YoutubeVideoData, channelDto: DTO_YoutubeChannelData) -> (
        search: Entity_YoutubeData,
        video: Entity_YoutubeVideoData,
        channel: Entity_YoutubeChannelData
    ) {
        let searchEntity = Entity_YoutubeData(
            videoId: searchDto.items.first?.id.videoID ?? "",
            title: searchDto.items.first?.snippet.title ?? "Unknown",
            thumbnailUrl: searchDto.items.first?.snippet.thumbnails.medium.url ?? "",
            channelId: searchDto.items.first?.snippet.channelId ?? "",
            channelName: "Unknown" // 기본값 설정 가능
        )
        
        let videoEntity = Entity_YoutubeVideoData(
            viewCount: videoDto.items.first?.statistics?.viewCount ?? "0"
        )
        let channelEntity = Entity_YoutubeChannelData(
            channelThumbnailUrl: channelDto.items.first?.snippet.thumbnails.medium.url ?? "" // ✅ 수정
        )
        return (search: searchEntity, video: videoEntity, channel: channelEntity)
    }
}
