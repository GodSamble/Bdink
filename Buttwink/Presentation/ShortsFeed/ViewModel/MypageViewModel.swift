//
//  ShortsFeedViewModel.swift
//  Buttwink
//
//  Created by 고영민 on 11/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import DesignSystem
import RxDataSources

// MARK: - Protocol Definitions

protocol ShortsFeedViewModelInput {
    var viewDidLoad: PublishRelay<Void> { get }
}

protocol ShortsFeedViewModelOutput {
    var snapshotRelay: PublishRelay<NSDiffableDataSourceSnapshot<SectionLayoutKind, DetailInfoSectionItem>> { get }
    var error: PublishRelay<Error> { get }
    var dataSource: BehaviorRelay<[DetailInfoSectionItem]> { get }
}

protocol ShortsFeedViewModelType {
    var inputs: ShortsFeedViewModelInput { get }
    var outputs: ShortsFeedViewModelOutput { get }
}

// MARK: - FeedViewModel Implementation

final class ShortsFeedViewModel: ShortsFeedViewModelType, ShortsFeedViewModelInput, ShortsFeedViewModelOutput {
    
    // MARK: - Inputs & Outputs
    var inputs: ShortsFeedViewModelInput { return self }
    var outputs: ShortsFeedViewModelOutput { return self }
    
    // MARK: - Input
    let viewDidLoad = PublishRelay<Void>()
    let fetchTrigger: PublishSubject<Void>
    let dataSource = BehaviorRelay<[DetailInfoSectionItem]>(value: [])
    
    // MARK: - Output
    private let itemsRelay = BehaviorRelay<[DetailInfoSectionItem]>(value: [])
    var error = PublishRelay<Error>()
    let snapshotRelay = PublishRelay<NSDiffableDataSourceSnapshot<SectionLayoutKind, DetailInfoSectionItem>>()
    var items: Driver<[DetailInfoSectionItem]>
    
    // MARK: - Properties (UseCase/ Mapper)
    private let videoIDsRelay = BehaviorRelay<[String]>(value: [])
    
    private let youtubeUseCase: YoutubeVideosUseCase
    private let youtubeMapper: DetailInfoSectionMapper

    private let disposeBag = DisposeBag()

    var somePartObservable: Observable<Int> {
        return Observable.just(20)
    }
    var someVideoIDsObservable: Observable<String> {
        return Observable.just("트포이")
    }
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Dummy Data
    
    let dummyData: [DetailInfoSectionItem] = [
        .Tag(["NPC", "NABBA", "WNGP"]),
        .Thumbnail([Entity_YoutubeData(videoId: "S3KEgDlkxC8", title: "CBUM 내년 우승 힘든 이유", thumbnailUrl: "", channelId: "UCgUmXnb08jZ6Ser6YoFGQBg", channelName: "TFE 트포이", channelThumbnailUrl: "https://i.ytimg.com/vi/S3KEgDlkxC8/default.jpg")]),
        .Third([UIImage.Icon.alarm_default!, UIImage.Icon.feed!, UIImage.Sample.sample1!])
    ]
    
    
    // MARK: - Initializer
    
    init(
        youtubeUseCase: YoutubeVideosUseCase,
        youtubeMapper: DetailInfoSectionMapper
    ) {
        self.youtubeUseCase = youtubeUseCase
        self.youtubeMapper = youtubeMapper
    
        self.items = itemsRelay.asDriver()
        
        self.fetchTrigger = PublishSubject<Void>()
    }
    
    // MARK: - Binding
    
    private func setupBindings() {
        fetchTrigger
            .withUnretained(self)
            .flatMapLatest { owner, _ -> Observable<[DetailInfoSectionItem]> in
                let videoIDsObservable: Observable<String> = owner.someVideoIDsObservable
                let partObservable: Observable<Int> = owner.somePartObservable

                return Observable.combineLatest(videoIDsObservable, partObservable) { query, maxResults in
                    return owner.fetchYoutube(query: query, maxResults: maxResults)
                }
                .flatMapLatest { $0 }
                .catchAndReturn([])
            }
            .asDriver(onErrorJustReturn: [])
            .drive(itemsRelay)
            .disposed(by: disposeBag)
    }

    
    func bind() {
        setupBindings()
        viewDidLoad.bind(to: fetchTrigger).disposed(by: disposeBag)
    }
    
    func fetchYoutube(query: String, maxResults: Int) -> Observable<[DetailInfoSectionItem]> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            self.isLoading.accept(true)
            
            Task {
                do {
                    let domainVideos = try await self.youtubeUseCase.execute(query: query, maxResults: maxResults)
                    let presentationVideos = self.youtubeMapper.transform(from: domainVideos)
                    
            var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, DetailInfoSectionItem>()
                    snapshot.appendSections([.tags])
                    snapshot.appendSections([.videoItem])
                    snapshot.appendSections([.thirdSection])
                    snapshot.appendItems(presentationVideos, toSection: .tags)
                    snapshot.appendItems(presentationVideos, toSection: .videoItem)
                    snapshot.appendItems(presentationVideos, toSection: .thirdSection)
                    
                    self.snapshotRelay.accept(snapshot)
                    
                    await MainActor.run {
                        observer.onNext(presentationVideos)
                        observer.onCompleted()
                        
                        self.isLoading.accept(false)
                        
                    }
                } catch {
                    await MainActor.run {
                        print("Error occurred: \(error)")
                        self.error.accept(error)
                        self.isLoading.accept(false)
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    public func getVideoIDs() -> [String] {
        return videoIDsRelay.value
    }
    
    internal func handleButtonTap(for buttonType: ButtonType) {
        switch buttonType {
        case .NPC:
            print("NPC button tapped")
        case .WNGP:
            print("WNGP button tapped")
        case .NABBA:
            print("NABBA button tapped")
        }
    }
}
