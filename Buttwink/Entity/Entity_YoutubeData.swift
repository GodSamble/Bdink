//
//  Entity_YoutubeData.swift
//  Buttwink
//
//  Created by 고영민 on 1/22/25.
//

import Foundation

struct Entity_YoutubeData {
    let cannelId: String
    let videoId: String
    let videoTitle: String
    let videoDescription: String?
    let duration: String?
    let viewCount: String?
    let publishedAt: String?
    let channelId: String?
    let channelName: String?
    let tags: [String]?
    let categoryId: String?
    let liveBroadcastContent: String?
    let defaultLanguage: String?
    let localized: Localized?
    let defaultAudioLanguage: String?
    let thumbnails: Thumbnails
    
    let likeCount: String
    let dislikeCount: String
    let favoriteCount: String
    let commentCount: String
}
