//
//  Mappers_YoutubeData.swift
//  Buttwink
//
//  Created by 고영민 on 1/23/25.
//

import Foundation


protocol Mappers_YoutubeData {
    func transform(_ dto: DTO_SearchData) -> [Entity_YoutubeData]
}

final class Mappers_YoutubeDataDefault: Mappers_YoutubeData {
    func transform(_ dto: DTO_SearchData) -> [Entity_YoutubeData] {
        return dto.items.map { items in
            // DTO -> Entity 변환
            Entity_YoutubeData(videoId: items.id.videoID, title: items.snippet.title, thumbnailUrl: items.snippet.thumbnails.default.url, channelId: items.snippet.channelId, channelName: items.snippet.channelTitle, channelThumbnailUrl: items.snippet.thumbnails.high.url
           
            )
        }
    }
    
}


