////
////  DTO_YoutubeData.swift
////  Buttwink
////
////  Created by 고영민 on 1/23/25.
////
//
//import Foundation
//
//// MARK: - DTO_YoutubeData_video
//struct DTO_YoutubeData: Codable, Hashable {
//    let kind, etag: String
//    let items: [VideoItem]
//    let pageInfo: PageInfo
//}
//
//// MARK: - VideoItem
//struct VideoItem: Codable, Hashable {
//    let kind, etag, id: String
//    let snippet: Snippet
//    let contentDetails: ContentDetails
//    let statistics: Statistics?
//}
//
//// MARK: - Snippet
//struct Snippet: Codable, Hashable {
//    let publishedAt: String
//    let channelId, title, description: String
//    let thumbnails: Thumbnails
//    let channelTitle: String
//    let tags: [String]?
//    let categoryId: String
//    let liveBroadcastContent: String
//    let defaultLanguage: String?
//    let localized: Localized
//    let defaultAudioLanguage: String?
//}
//
//// MARK: - Localized
//struct Localized: Codable, Hashable {
//    let title, description: String
//}
//
//// MARK: - Thumbnails
//struct Thumbnails: Codable, Hashable {
//    let `default`, medium, high: Thumbnail
//    let standard, maxres: Thumbnail?
//}
//
//// MARK: - Thumbnail
//struct Thumbnail: Codable, Hashable {
//    let url: String
//    let width, height: Int
//}
//
//// MARK: - ContentDetails
//struct ContentDetails: Codable, Hashable {
//    let duration: String
//    let dimension: String
//    let definition: String
//    let caption: String
//    let licensedContent: Bool
//    let contentRating: ContentRating?
//    let projection: String
//}
//
//// MARK: - ContentRating
//struct ContentRating: Codable, Hashable {
//    // Define specific fields if needed, otherwise, you can leave this empty for now
//}
//
//// MARK: - Statistics
//struct Statistics: Codable, Hashable {
//    let viewCount, likeCount, dislikeCount, favoriteCount, commentCount: String?
//}
//
//// MARK: - PageInfo
//struct PageInfo: Codable, Hashable {
//    let totalResults, resultsPerPage: Int
//}
//
//
