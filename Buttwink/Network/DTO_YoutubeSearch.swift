//
//  DTO_YoutubeSearch.swift
//  Buttwink
//
//  Created by 고영민 on 2/11/25.
//

import Foundation


struct Entity_YoutubeShorts {
    let videoId: String            // 영상 URL을 만들기 위한 ID
    let title: String              // 영상 제목
    let thumbnailUrl: String       // 쇼츠 썸네일 URL
//    let firstComment: String?      // 첫 번째 댓글 (선택적)
    let channelId: String          // 채널 ID
    let channelName: String        // 채널 이름
    let channelThumbnailUrl: String // 채널 프로필 사진
}

// MARK: - 공통 엔티티 (Shared Entities)
struct PageInfo: Codable, Hashable {
    let totalResults, resultsPerPage: Int
}

// MARK: - Snippet (공통)
struct Snippet: Codable, Hashable {
    let publishedAt: String
    let channelId, title, description: String
    let thumbnails: Thumbnails
    let channelTitle: String
    let liveBroadcastContent: String
}

// MARK: - Thumbnails (공통)
struct Thumbnails: Codable, Hashable {
    let `default`, medium, high: Thumbnail
    let standard, maxres: Thumbnail?
}

// MARK: - Thumbnail (공통)
struct Thumbnail: Codable, Hashable {
    let url: String
    let width, height: Int
}

// MARK: - DTO_YoutubeData_video (Video API)
struct DTO_YoutubeData: Codable, Hashable {
    let kind, etag: String
    let items: [VideoItem]
    let pageInfo: PageInfo
}

// MARK: - VideoItem (Video API 전용)
struct VideoItem: Codable, Hashable {
    let kind, etag, id: String
    let snippet: Snippet
    let contentDetails: ContentDetails
    let statistics: Statistics?
}

// MARK: - ContentDetails (Video API 전용)
struct ContentDetails: Codable, Hashable {
    let duration: String
    let dimension: String
    let definition: String
    let caption: String
    let licensedContent: Bool
    let contentRating: ContentRating?
    let projection: String
}

// MARK: - Statistics (Video API 전용)
struct Statistics: Codable, Hashable {
    let viewCount, likeCount, dislikeCount, favoriteCount, commentCount: String?
}

// MARK: - ContentRating (Video API 전용)
struct ContentRating: Codable, Hashable {}

// MARK: - YoutubeSearch (Search API)
struct DTO_SearchData: Codable {
    let kind, etag, nextPageToken, regionCode: String
    let pageInfo: PageInfo
    let items: [SearchItem]
}

// MARK: - SearchItem (Search API 전용)
struct SearchItem: Codable {
    let kind: ItemKind
    let etag: String
    let id: VideoID
    let snippet: Snippet
}

// MARK: - VideoID (Search API 전용)
struct VideoID: Codable {
    let kind: IDKind
    let videoID: String

    enum CodingKeys: String, CodingKey {
        case kind
        case videoID = "videoId"
    }
}

enum IDKind: String, Codable {
    case youtubeVideo = "youtube#video"
}

enum ItemKind: String, Codable {
    case youtubeSearchResult = "youtube#searchResult"
}

// MARK: - DTO_YoutubeChannelData (Channels API)
struct DTO_YoutubeChannelData: Codable, Hashable {
    let kind, etag: String
    let items: [ChannelItem]
}

// MARK: - ChannelItem (Channels API 전용)
struct ChannelItem: Codable, Hashable {
    let id: String
    let snippet: ChannelSnippet
    let statistics: ChannelStatistics?
}

// MARK: - ChannelSnippet (채널 정보)
struct ChannelSnippet: Codable, Hashable {
    let title: String
    let description: String
    let thumbnails: Thumbnails
    let publishedAt: String
}

// MARK: - ChannelStatistics (채널 통계)
struct ChannelStatistics: Codable, Hashable {
    let viewCount: String?
    let subscriberCount: String?
    let hiddenSubscriberCount: Bool?
    let videoCount: String?
}


// MARK: - DTO_YoutubeVideoData (Video API)
struct DTO_YoutubeVideoData: Codable, Hashable {
    let kind, etag: String
    let items: [VideoItemDetails]
    let pageInfo: PageInfo
}

// MARK: - VideoItemDetails (Video API 전용)
struct VideoItemDetails: Codable, Hashable {
    let kind, etag, id: String
    let snippet: Snippet
    let statistics: VideoStatistics?
}

// MARK: - VideoStatistics (Video API 전용)
struct VideoStatistics: Codable, Hashable {
    let viewCount: String?
}
