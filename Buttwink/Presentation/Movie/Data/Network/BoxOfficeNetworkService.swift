//
//  BoxOfficeNetworkService.swift
//  Buttwink
//
//  Created by 이지훈 on 12/25/24.
//

import Foundation
import Moya

protocol BoxOfficeNetworkService {
    func fetchDailyBoxOffice(date: Date) async throws -> BoxOfficeDTO
}

final class DefaultBoxOfficeNetworkService: BoxOfficeNetworkService {
    private let provider: MoyaProvider<BoxOfficeAPI>
    
    init(provider: MoyaProvider<BoxOfficeAPI> = .init()) {
        self.provider = provider
    }
    
    func fetchDailyBoxOffice(date: Date) async throws -> BoxOfficeDTO {
        let dateString = DateFormatter.yyyyMMdd.string(from: date)
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.dailyBoxOffice(date: dateString)) { result in
                switch result {
                case .success(let response):
                    do {
                        let dto = try response.map(BoxOfficeDTO.self)
                        continuation.resume(returning: dto)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
