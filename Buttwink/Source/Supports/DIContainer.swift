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
        container.register(TestService.self) { _ in
            let provider = CustomMoyaProvider<TestAPI>()
            return TestService(provider: provider)
        }

        container.register(Repository_test.self) { resolver in
            let service = resolver.resolve(TestService.self)!
            return Repository_test(service: service, lat: 3.0, lon: 3.0)
        }

        container.register(MypageViewModel.self) { resolver in
            let repository = resolver.resolve(Repository_test.self)!
            return MypageViewModel(repository: repository)
        }

        container.register(MypageViewController.self) { resolver in
            let viewModel = resolver.resolve(MypageViewModel.self)!
            return MypageViewController(viewModel: viewModel)
        }
    }
}
