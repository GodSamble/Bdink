//
//  MovieViewModel.swift
//  Buttwink
//
//  Created by 이지훈 on 12/25/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieViewModelInput {
    var fetchTrigger: PublishRelay<Void> { get }
}

protocol MovieViewModelOutput {
    var movies: BehaviorRelay<[MoviePresentationModel]> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var error: PublishRelay<Error> { get }
}

protocol MovieViewModelType {
    var inputs: MovieViewModelInput { get }
    var outputs: MovieViewModelOutput { get }
}

 class MovieViewModel: MovieViewModelType, MovieViewModelInput, MovieViewModelOutput {
    
    var inputs: MovieViewModelInput { return self }
    var outputs: MovieViewModelOutput { return self }
    
    // MARK: - Input
    let fetchTrigger = PublishRelay<Void>()
    
    // MARK: - Output
    let movies = BehaviorRelay<[MoviePresentationModel]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishRelay<Error>()
    
    private let fetchMoviesUseCase: FetchMoviesUseCase
    private let moviePresentationMapper: MoviePresentationMapper
    private let disposeBag = DisposeBag()
    
    init(
        fetchMoviesUseCase: FetchMoviesUseCase,
        moviePresentationMapper: MoviePresentationMapper
    ) {
        self.fetchMoviesUseCase = fetchMoviesUseCase
        self.moviePresentationMapper = moviePresentationMapper
        setupBindings()
    }
    
    private func setupBindings() {
        fetchTrigger
            .withUnretained(self)
            .flatMapLatest { owner, _ -> Observable<[MoviePresentationModel]> in
                return owner.fetchMovies()
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func fetchMovies() -> Observable<[MoviePresentationModel]> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            self.isLoading.accept(true)
            
            Task {
                do {
                    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                    
                    let domainMovies = try await self.fetchMoviesUseCase.execute(date: yesterday)
                    
                    let presentationMovies = self.moviePresentationMapper.transform(domainMovies)
                    
                    await MainActor.run {
                        self.movies.accept(presentationMovies)
                        self.isLoading.accept(false)
                        observer.onNext(presentationMovies)
                        observer.onCompleted()
                    }
                } catch {
                    await MainActor.run {
                        self.error.accept(error)
                        self.isLoading.accept(false)
                        observer.onError(error)
                    }
                }
            }
            
            return Disposables.create()
        }
    }
}
