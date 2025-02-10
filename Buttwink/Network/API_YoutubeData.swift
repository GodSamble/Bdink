//  API_YoutubeData.swift
//  Buttwink
//
//  Created by 고영민 on 1/22/25.
//

import Foundation
import Moya

enum API_YoutubeData {
    case video(id: String, part: String)
}

extension API_YoutubeData: TargetType {
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .video(let id, let part):
            return .requestParameters(
                parameters: commonParameters(id: id, part: part),
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
        }
    }
    
    private func commonParameters(id: String, part: String) -> [String: Any] {
        return [
            "key": fetchAPIKey(), // 보안 파일에서 API 키 가져오기
            "id": id, // 비디오 ID
            "part": part // 반환할 데이터 유형 (예: "snippet", "contentDetails", "statistics" 등)
        ]
    }
    
    private func fetchAPIKey() -> String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "YoutubeAPIKey") as? String else {
            fatalError("API Key is missing in Info.plist")
        }
        return apiKey
    }
}
