//
//  Usecase_test.swift
//  Buttwink
//
//  Created by 고영민 on 12/10/24.
//

import Foundation
import RxSwift

protocol UseCaseProtocol_test {
    func dataAsync() async throws -> Welcome
}

final class UseCase_test: UseCaseProtocol_test {
    private let repositoryInterface: RepositoryInterface_test
    
    init(repositoryInterface: RepositoryInterface_test) {
        self.repositoryInterface = repositoryInterface
    }
    
    func dataAsync() async throws -> Welcome {
        return try await self.repositoryInterface.dataAsync()
    }
}


//MARK: ⭐️ 여러 Repository 병합 / 특정 조건으로 데이터 필터링 / 에러 처리 및 기본값 제공
//MARK: 이것들을 UseCase를 통해 가공 & 설정해둘 수 있음.
