//
//  MoviewViewModel.swift
//  Buttwink
//
//  Created by 이지훈 on 12/22/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieViewModelInput {
    var fetchTrigger: PublishRelay<Void> { get }
}

protocol MovieViewModelOutput {
    var movies: BehaviorRelay<[MovieModel]> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var error: PublishRelay<Error> { get }
}

protocol MovieViewModelType {
    var inputs: MovieViewModelInput { get }
    var outputs: MovieViewModelOutput { get }
}

final class MovieViewModel: MovieViewModelType, MovieViewModelInput, MovieViewModelOutput {
    
    var inputs: MovieViewModelInput { return self }
    var outputs: MovieViewModelOutput { return self }
    
    // MARK: - Input
    let fetchTrigger = PublishRelay<Void>()
    
    // MARK: - Output
    let movies = BehaviorRelay<[MovieModel]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishRelay<Error>()
        
    private let boxOfficeService: BoxOfficeServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(boxOfficeService: BoxOfficeServiceProtocol = BoxOfficeService()) {
        self.boxOfficeService = boxOfficeService
        setupBindings()
    }
    
    private func setupBindings() {
        fetchTrigger
            .withUnretained(self)
            .flatMapLatest { owner, _ -> Observable<[MovieModel]> in
                return owner.fetchMovies()
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func fetchMovies() -> Observable<[MovieModel]> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            self.isLoading.accept(true)
            
            Task {
                do {
                    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                    let dateString = DateFormatter.yyyyMMdd.string(from: yesterday)
                    
                    let newMovies = try await Task.detached(priority: .userInitiated) {
                        return try await self.boxOfficeService.fetchDailyBoxOffice(date: dateString)
                    }.value
                    
                    await MainActor.run {
                        self.movies.accept(newMovies)
                        self.isLoading.accept(false)
                        observer.onNext(newMovies)
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
