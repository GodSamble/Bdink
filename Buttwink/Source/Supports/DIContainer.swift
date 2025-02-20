//
//  DIContainer.swift
//  Buttwink
//
//  Created by 고영민 on 12/15/24.
//

import Foundation
import Swinject
import Moya

final class DIContainer {
    static let shared = DIContainer()
    let container = Container()
    
    private init() {
        // TestService 등록
        container.register(YoutubeDataService.self) { _ in
            let provider = MoyaProvider<API_YoutubeData>()
            return DefaultYoutubeNetworkService(provider: provider)
        }
        
        // Register Mappers_YoutubeDataDefault
        container.register(Mappers_YoutubeDataDefault.self) { _ in
            Mappers_YoutubeDataDefault()
        }
        
        // Register RepositoryInterface_Youtube
        container.register(RepositoryInterface_Youtube.self) { resolver in
            let service = resolver.resolve(YoutubeDataService.self)!
            let mapper = resolver.resolve(Mappers_YoutubeDataDefault.self)!
            return Repository_Youtube(networkService: service, mapper: mapper)
        }
        
        
        // UseCase_test 등록
        container.register(FetchUnifiedYoutubeDataUseCase.self) { resolver in
            let repository = resolver.resolve(RepositoryInterface_Youtube.self)!
            return FetchUnifiedYoutubeDataUseCaseImpl(repositoryInterface_Youtube: repository)
        }
        
        // MypageMapper 등록
        container.register(DetailInfoSectionMapper.self) { _ in
            DetailInfoSectionMapperImpl()
        }
        
        // ShortsFeedViewModel 등록
        container.register(ShortsFeedViewModel.self) { resolver in
            guard let useCase = resolver.resolve(FetchUnifiedYoutubeDataUseCase.self) else {
                fatalError("Failed to resolve YoutubeVideosUseCase") // UseCase가 없으면 앱 종료
            }
            
            // DetailInfoSectionMapper 의존성 안전하게 해결
            guard let mapper = resolver.resolve(DetailInfoSectionMapper.self) else {
                fatalError("Failed to resolve DetailInfoSectionMapper") // Mapper가 없으면 앱 종료
            }
            return ShortsFeedViewModel(youtubeUseCase: useCase, youtubeMapper: mapper)
        }
        
        // ShortsFeedViewController 등록
        container.register(ShortsFeedViewController.self) { resolver in
            let viewModel = resolver.resolve(ShortsFeedViewModel.self)!
            return ShortsFeedViewController(viewModel: viewModel)
        }
    }
}

