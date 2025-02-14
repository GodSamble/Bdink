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
        let tags = models.map { $0.channelId }
        
        let videoItems: [Entity_YoutubeData] = models.map { model in
                   return Entity_YoutubeData(
                       videoId: model.videoId,
                       title: model.title,
                       thumbnailUrl: model.thumbnailUrl,
                       channelId: model.channelId,
                       channelName: model.channelName,
                       channelThumbnailUrl: model.channelThumbnailUrl
                   )
               }
        
        let placeholderImages = [UIImage(named: "placeholder") ?? UIImage()]
        
        return [
            .Tag(["WNGP", "NABBA", "NOVICE"]),
            .Thumbnail(videoItems),
            .Third(placeholderImages)
        ]
    }
}
