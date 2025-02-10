//
//  Mappers_YoutubeData.swift
//  Buttwink
//
//  Created by 고영민 on 1/23/25.
//

import Foundation


protocol Mappers_YoutubeData {
    func transform(_ dto: DTO_YoutubeData) -> [Entity_YoutubeData]
}

final class Mappers_YoutubeDataDefault: Mappers_YoutubeData {
    func transform(_ dto: DTO_YoutubeData) -> [Entity_YoutubeData] {
        return dto.items.map { items in
            // DTO -> Entity 변환
            Entity_YoutubeData(
                cannelId: items.snippet.channelId, // channelId를 cannelName에 매핑
                videoId: items.id, // videoId는 VideoItem의 id에서 가져오기
                videoTitle: items.snippet.title, // videoTitle은 Snippet의 title
                videoDescription: items.snippet.description, // videoDescription은 Snippet의 description
                duration: items.contentDetails.duration, // duration은 ContentDetails의 duration
                viewCount: items.statistics?.viewCount, // viewCount는 Statistics에서 가져오기
                publishedAt: items.snippet.publishedAt, // publishedAt은 Snippet에서 가져오기
                channelId: items.snippet.channelId, // channelId는 Snippet에서 가져오기
                channelName: items.snippet.channelTitle, // channelName은 Snippet에서 가져오기
                tags: items.snippet.tags, // tags는 Snippet에서 가져오기
                categoryId: items.snippet.categoryId, // categoryId는 Snippet에서 가져오기
                liveBroadcastContent: items.snippet.liveBroadcastContent, // liveBroadcastContent는 Snippet에서 가져오기
                defaultLanguage: items.snippet.defaultLanguage, // defaultLanguage는 Snippet에서 가져오기
                localized: items.snippet.localized, // localized은 Snippet에서 가져오기
                defaultAudioLanguage: items.snippet.defaultAudioLanguage, // defaultAudioLanguage는 Snippet에서 가져오기
                thumbnails: items.snippet.thumbnails, // thumbnails는 Snippet에서 가져오기
                likeCount: items.statistics?.likeCount ?? "", // likeCount는 Statistics에서 가져오기
                dislikeCount: items.statistics?.dislikeCount ?? "", // dislikeCount는 Statistics에서 가져오기
                favoriteCount: items.statistics?.favoriteCount ?? "", // favoriteCount는 Statistics에서 가져오기
                commentCount: items.statistics?.commentCount ?? "" // commentCount는 Statistics에서 가져오기
            )
        }
    }
    
}


