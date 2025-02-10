////
////  DTO_YoutubeData_Video.swift
////  Buttwink
////
////  Created by 고영민 on 1/23/25.
////
//
//// MARK: - ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
//import Foundation
//
//// MARK: - Welcome
//struct DTO_YoutubeData_video: Codable {
//    let kind, etag: String
//    let items: [Item]
//    let nextPageToken: String
//    let pageInfo: PageInfo
//}
//
//// MARK: - Item
//struct Item: Codable {
//    let kind: Kind
//    let etag, id: String
//    let snippet: Snippet
//}
//
//enum Kind: String, Codable {
//    case youtubeVideo = "youtube#video"
//}
//
//// MARK: - Snippet
//struct Snippet: Codable {
//    let publishedAt: Date
//    let channelID, title, description: String
//    let thumbnails: Thumbnails
//    let channelTitle: String
//    let tags: [String]?
//    let categoryID: String
//    let liveBroadcastContent: LiveBroadcastContent
//    let localized: Localized
//    let defaultAudioLanguage, defaultLanguage: DefaultLanguage?
//
//    enum CodingKeys: String, CodingKey {
//        case publishedAt
//        case channelID = "channelId"
//        case title, description, thumbnails, channelTitle, tags
//        case categoryID = "categoryId"
//        case liveBroadcastContent, localized, defaultAudioLanguage, defaultLanguage
//    }
//}
//
//enum DefaultLanguage: String, Codable {
//    case en = "en"
//    case enGB = "en-GB"
//    case enUS = "en-US"
//}
//
//enum LiveBroadcastContent: String, Codable {
//    case none = "none"
//}
//
//// MARK: - Localized
//struct Localized: Codable {
//    let title, description: String
//}
//
//// MARK: - Thumbnails
//struct Thumbnails: Codable {
//    let thumbnailsDefault, medium, high, standard: Default
//    let maxres: Default?
//
//    enum CodingKeys: String, CodingKey {
//        case thumbnailsDefault = "default"
//        case medium, high, standard, maxres
//    }
//}
//
//// MARK: - Default
//struct Default: Codable {
//    let url: String
//    let width, height: Int
//}
//
//// MARK: - PageInfo
//struct PageInfo: Codable {
//    let totalResults, resultsPerPage: Int
//}
