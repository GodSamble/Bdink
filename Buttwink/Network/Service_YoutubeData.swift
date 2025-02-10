//
//  Service_YoutubeData.swift
//  Buttwink
//
//  Created by 고영민 on 1/22/25.
//

import Foundation
import Moya

protocol YoutubeDataService {
    func fetchYoutubeData(id: String, part: String) async throws -> DTO_YoutubeData
}

final class DefaultYoutubeNetworkService: YoutubeDataService {
    
    private let provider: MoyaProvider<API_YoutubeData>
    
    init(provider: MoyaProvider<API_YoutubeData> = .init()) {
        self.provider = provider
    }
    
    func fetchYoutubeData(id: String, part: String = "snippet") async throws -> DTO_YoutubeData {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else { return }
            
            self.provider.request(.video(id: id, part: part)) { result in
                switch result {
                case .success(let response):
                    do {
                        // 상태 코드 확인 (200인지 검증)
                        guard (200...299).contains(response.statusCode) else {
                            throw NSError(
                                domain: "YoutubeAPIError",
                                code: response.statusCode,
                                userInfo: [NSLocalizedDescriptionKey: "Invalid status code: \(response.statusCode)"]
                            )
                        }
                        print("Response Data: \(String(data: response.data, encoding: .utf8) ?? "Invalid Data")")
                        // DTO로 디코딩
                        let dto = try response.map(DTO_YoutubeData.self)
                        print("Decoded DTO: \(dto)")
                        continuation.resume(returning: dto)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
