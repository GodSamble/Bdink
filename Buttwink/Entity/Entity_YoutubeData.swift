//
//  Entity_YoutubeData.swift
//  Buttwink
//
//  Created by 고영민 on 1/22/25.
//

import Foundation

struct UnifiedYoutubeEntity : Hashable{
    let viewCount: String?           // 조회수
    let channelThumbnailUrl: String? // 썸네일
    var videoId: String?             // 영상 URL을 만들기 위한 ID
//    let firstComment: String?
    let title: String                // 영상 제목
    let thumbnailUrl: String         // 쇼츠 썸네일 URL
    let channelId: String            // 채널 ID
    let channelName: String          // 채널 이름
}

struct Entity_YoutubeData: Hashable {        // MARK: SEARCH✅
    var videoId: String?              // 영상 URL을 만들기 위한 ID
    let title: String                 // 영상 제목
    let thumbnailUrl: String          // 쇼츠 썸네일 URL
    let channelId: String             // 채널 ID
    let channelName: String           // 채널 이름
}

struct Entity_YoutubeChannelData: Hashable { // MARK: CHANNEL✅
//    let channelId: String
//    let channelName: String
    let channelThumbnailUrl: String   // 채널 프로필 사진
//    let description: String?
}

struct Entity_YoutubeVideoData: Hashable {
//    let videoId: String
//    let title: String                       // MARK: VIDEO ✅
    let viewCount: String              // 조회수
//    let thumbnailUrl: String
//    let publishedAt: String
//    let description: String?
}
