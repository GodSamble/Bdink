//
//  Repository_test.swift
//  Buttwink
//
//  Created by 고영민 on 12/10/24.
//

import Foundation
import RxSwift
import Moya

final class Repository_test: RepositoryInterface_test {
    
    private let service: TestService
    
    init(service: TestService) {
        self.service = service
    }
    
    func fetchGetMethod(lat: Double, lon: Double) async throws -> [Welcome] {
        let dto = try await service.getTotalTest(lat: lat, lon: lon).async()
        guard let data = dto.data else {
            throw NSError(domain: "RepositoryError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data is missing"])
        }
        return [data]
    }
}





//MARK: Concurrency와 RxSwift 혼용시 편의를 위한 익스텐션
extension Observable {
    func async() async throws -> Element {
        try await withCheckedThrowingContinuation { continuation in
            let disposable = self.subscribe(
                onNext: { value in
                    continuation.resume(returning: value)
                },
                onError: { error in
                    continuation.resume(throwing: error)
                }
            )
            _ = Disposables.create { disposable.dispose() }
        }
    }
}
