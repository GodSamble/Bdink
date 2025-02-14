//  API_YoutubeData.swift
//  Buttwink
//
//  Created by 고영민 on 1/22/25.
//

import Foundation
import Moya

enum API_YoutubeData {
//    case video(id: String, part: String)
    case search(query: String, maxResults: Int)
}

extension API_YoutubeData: TargetType {
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
//        case .video(let id, let part):
//            return .requestParameters(
//                parameters: commonParameters(id: id, part: part),
//                encoding: URLEncoding.default
//            )
        case .search(let query, let maxResults):
            return .requestParameters(
                parameters: searchParameters(query: query, maxResults: maxResults),
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
//        case .video:
//            return "/videos"
        case .search:
            return "/search"
        }
    }
    
    private func commonParameters(id: String, part: String) -> [String: Any] {
        return [
            "key": fetchAPIKey(), // 보안 파일에서 API 키 가져오기
            "id": id, // 비디오 ID
            "part": part // 반환할 데이터 유형 (예: "snippet", "contentDetails", "statistics" 등)
        ]
    }
    
    private func searchParameters(query: String, maxResults: Int) -> [String: Any] {
        return [
            "key": fetchAPIKey(), // 보안 파일에서 API 키 가져오기
            "q": query, // 검색어 (ex: "트포이")
            "part": "snippet", // 기본 정보 포함
            "type": "video", // 비디오만 검색
            "videoDuration": "short", // Shorts (60초 이하)
            "order": "viewCount", // 조회수 기준 정렬
            "regionCode": "KR", // 한국 인기 영상
            "maxResults": maxResults // 최대 가져올 영상 수
        ]
    }
    
    private func fetchAPIKey() -> String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "YOUTUBE_API_KEY") as? String else {
            fatalError("API Key is missing in Info.plist")
        }
        return apiKey
    }
}
