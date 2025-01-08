//
//  DIContainer.swift
//  Buttwink
//
//  Created by 고영민 on 12/15/24.
//

import Foundation
import Swinject

final class DIContainer {
    static let shared = DIContainer()
    let container = Container()

    private init() {
        // TestService 등록
        container.register(TestService.self) { _ in
            let provider = CustomMoyaProvider<TestAPI>()
            return TestService(provider: provider)
        }

        // Repository_test 등록
        container.register(RepositoryInterface_test.self) { resolver in
            let service = resolver.resolve(TestService.self)!
            return Repository_test(service: service)
        }

        // UseCase_test 등록
        container.register(UseCaseProtocol_test.self) { resolver in
            let repository = resolver.resolve(RepositoryInterface_test.self)!
            return UseCase_test(repositoryInterface: repository)
        }

        // MypageMapper 등록
        container.register(MypageMapper.self) { _ in
            DefaultMypagePresentationMapper()
        }

        // MypageViewModel 등록
        container.register(MypageViewModel.self) { resolver in
            let useCase = resolver.resolve(UseCaseProtocol_test.self)!
            guard let mapper = resolver.resolve(MypageMapper.self) else {
                fatalError("Failed to resolve MypageMapper")
            }
            return MypageViewModel(fetchUseCase: useCase, presentationMapper: mapper)
        }

        // MypageViewController 등록
        container.register(MypageViewController.self) { resolver in
            let viewModel = resolver.resolve(MypageViewModel.self)!
            return MypageViewController(viewModel: viewModel)
        }
    }
}

