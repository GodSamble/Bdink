//
//  ShortsMapper.swift
//  Buttwink
//
//  Created by 고영민 on 1/23/25.
//

import UIKit

protocol DetailInfoSectionMapper {
    func transform(from models: [Entity_YoutubeData]) -> [DetailInfoSectionItem]
}

final class DetailInfoSectionMapperImpl: DetailInfoSectionMapper {
    func transform(from models: [Entity_YoutubeData]) -> [DetailInfoSectionItem] {
        let tags = models.map { $0.cannelId }
        
        let videoItems: [VideoItem] = models.map { model in
            let snippet = Snippet(
                publishedAt: model.publishedAt ?? "", // 기본값 처리
                channelId: model.channelId ?? "", // 기본값 처리
                title: model.videoTitle,
                description: model.videoDescription ?? "", // 기본값 처리
                thumbnails: model.thumbnails, // 기본값 처리
                channelTitle: model.channelName ?? "", // 기본값 처리
                tags: model.tags ?? [], // 기본값 처리
                categoryId: model.categoryId ?? "", // 기본값 처리
                liveBroadcastContent: model.liveBroadcastContent ?? "", // 기본값 처리
                defaultLanguage: model.defaultLanguage ?? "", // 기본값 처리
                localized: model.localized ?? Localized(title: "", description: ""), // 기본값 처리
                defaultAudioLanguage: model.defaultAudioLanguage ?? "" // 기본값 처리
            )
            
            // ContentDetails와 Statistics 타입 명시
            let contentDetails = ContentDetails(
                duration: model.duration ?? "", // 기본값 처리
                dimension: "", // 기본값 처리
                definition: "", // 기본값 처리
                caption: "", // 기본값 처리
                licensedContent: false, // 기본값 처리
                contentRating: nil, // 기본값 처리
                projection: "" // 기본값 처리
            )
            
            let statistics = Statistics(
                viewCount: model.viewCount ?? "", // 기본값 처리
                likeCount: model.likeCount ?? "", // 기본값 처리
                dislikeCount: model.dislikeCount ?? "", // 기본값 처리
                favoriteCount: model.favoriteCount ?? "", // 기본값 처리
                commentCount: model.commentCount ?? "" // 기본값 처리
            )
            
            return VideoItem(
                kind: "youtube#video",
                etag: "someEtag",
                id: model.videoId,
                snippet: snippet,
                contentDetails: contentDetails,
                statistics: statistics
            )
        }
        
        let placeholderImages = [UIImage(named: "placeholder") ?? UIImage()]
        
        return [
            .Tag(tags),
            .Thumbnail(videoItems),
            .Third(placeholderImages)
        ]
    }
}
