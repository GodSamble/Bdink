//
//  Service_YoutubeData.swift
//  Buttwink
//
//  Created by 고영민 on 1/22/25.
//

import Foundation
import Moya

protocol YoutubeDataService {
    func fetchYoutubeData(ids: [String], part: String) async throws -> DTO_YoutubeVideoData
    func fetchYoutubeSearch(query: String, maxResults: Int) async throws -> DTO_SearchData
    func fetchYoutubeChannel(ids: [String], part: String) async throws -> DTO_YoutubeChannelData
}

final class DefaultYoutubeNetworkService: YoutubeDataService {
    
    private let provider: MoyaProvider<API_YoutubeData>
    
    init(provider: MoyaProvider<API_YoutubeData> = .init()) {
        self.provider = provider
    }
    
    func fetchYoutubeData(ids: [String], part: String = "snippet") async throws -> DTO_YoutubeVideoData {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else { return }
            
            print("🚀 Request Sent: \(API_YoutubeData.video(ids: ids, part: part))") // 요청 디버깅
            
            self.provider.request(.video(ids: ids, part: part)) { result in
                switch result {
                case .success(let response):
                    do {
                        print("✅ Response Status Code: \(response.statusCode)")
                        print("📌 Response Data: \(String(data: response.data, encoding: .utf8) ?? "Invalid Data")")
                        
                        guard (200...299).contains(response.statusCode) else {
                            throw NSError(
                                domain: "YoutubeAPIError",
                                code: response.statusCode,
                                userInfo: [NSLocalizedDescriptionKey: "Invalid status code: \(response.statusCode)"]
                            )
                        }
                        
                        let dto = try response.map(DTO_YoutubeVideoData.self)
                        print("🟢 Decoded DTO: \(dto)")
                        continuation.resume(returning: dto)
                    } catch {
                        print("❌ Decoding Error: \(error)")
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    print("❌ Failure: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func fetchYoutubeSearch(query: String, maxResults: Int) async throws -> DTO_SearchData {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else { return }
            
            print("🚀 Request Sent: \(API_YoutubeData.search(query: query, maxResults: maxResults))") // 요청 디버깅
            
            self.provider.request(.search(query: query, maxResults: maxResults)) { result in
                switch result {
                case .success(let response):
                    do {
                        print("✅ Response Status Code: \(response.statusCode)")
                        print("📌 Response Data: \(String(data: response.data, encoding: .utf8) ?? "Invalid Data")")
                        
                        guard (200...299).contains(response.statusCode) else {
                            throw NSError(
                                domain: "YoutubeAPIError",
                                code: response.statusCode,
                                userInfo: [NSLocalizedDescriptionKey: "Invalid status code: \(response.statusCode)"]
                            )
                        }
                        
                        let dto = try response.map(DTO_SearchData.self)
                        print("🟢 Decoded DTO: \(dto)")
                        continuation.resume(returning: dto)
                    } catch {
                        print("❌ Decoding Error: \(error)")
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    print("❌ Failure: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func fetchYoutubeChannel(ids: [String], part: String) async throws -> DTO_YoutubeChannelData {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else { return }
            
            print("🚀 Request Sent: \(API_YoutubeData.channel(ids: ids, part: part))") // 요청 디버깅
            
            self.provider.request(.channel(ids: ids, part: part)) { result in
                switch result {
                case .success(let response):
                    do {
                        print("✅ Response Status Code: \(response.statusCode)")
                        print("📌 Response Data: \(String(data: response.data, encoding: .utf8) ?? "Invalid Data")")
                        
                        guard (200...299).contains(response.statusCode) else {
                            throw NSError(
                                domain: "YoutubeAPIError",
                                code: response.statusCode,
                                userInfo: [NSLocalizedDescriptionKey: "Invalid status code: \(response.statusCode)"]
                            )
                        }
                        
                        let dto = try response.map(DTO_YoutubeChannelData.self)
                        print("🟢 Decoded DTO: \(dto)")
                        continuation.resume(returning: dto)
                    } catch {
                        print("❌ Decoding Error: \(error)")
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    print("❌ Failure: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
