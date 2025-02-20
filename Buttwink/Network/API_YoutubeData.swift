//  API_YoutubeData.swift
//  Buttwink
//
//  Created by 고영민 on 1/22/25.
//

import Foundation
import Moya

enum API_YoutubeData {
    case video(ids: [String], part: String)
    case search(query: String, maxResults: Int) // 수정된 부분
    case channel(ids: [String], part: String) // 채널 ID도 추가
}

extension API_YoutubeData: TargetType {
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .video(let ids, let part):
            return .requestParameters(
                parameters: commonParameters(ids: ids, part: part),
                encoding: URLEncoding.default
            )
        case .channel(let ids, let part):
            return .requestParameters(
                parameters: commonParameters(ids: ids, part: part),
                encoding: URLEncoding.default
            )
        case .search(let query, let maxResults): // 수정된 부분
            return .requestParameters(
                parameters: searchParameters(query: query, maxResults: maxResults), // 수정된 부분
                encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    var baseURL: URL {
        return URL(string: "https://www.googleapis.com/youtube/v3")!
    }
    
    var path: String {
        switch self {
        case .video:
            return "/videos"
        case .search:
            return "/search"
        case .channel:
            return "/channels"
        }
    }
    
    private func commonParameters(ids: [String], part: String) -> [String: Any] {
        return [
            "key": fetchAPIKey(),
            "id": ids.joined(separator: ","),
            "part": part
        ]
    }
    
    private func searchParameters(query: String, maxResults: Int) -> [String: Any] { // 수정된 부분
        return [
            "key": fetchAPIKey(),
            "q": query, // 따옴표 빼야하나
            "part": "snippet",
            "type": "video",
            "videoDuration": "short",
            "order": "viewCount",
            "regionCode": "KR",
            "maxResults": maxResults // 따옴표 빼야하나
        ]
    }
    
    private func commonParameters(part: String) -> [String: Any] {
        return [
            "key": fetchAPIKey(),
            "part": part
        ]
    }
    
    private func fetchAPIKey() -> String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "YOUTUBE_API_KEY") as? String else {
            fatalError("API Key is missing in Info.plist")
        }
        return apiKey
    }
}
