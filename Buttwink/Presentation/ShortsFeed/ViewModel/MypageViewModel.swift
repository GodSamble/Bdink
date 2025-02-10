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
    
    var somePartObservable: Observable<String> {
        return Observable.just("snippet,contentDetails,statistics")
    }
    var someVideoIDsObservable: Observable<[String]> {
        return Observable.just(["", "", ""])
    }
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Dummy Data
    
    let dummyData: [DetailInfoSectionItem] = [
        .Tag(["NPC", "NABBA", "WNGP"]),
        .Thumbnail([VideoItem(
            kind: "youtube#video",
            etag: "someEtag",
            id: "dQw4w9WgXcQ",
            snippet: Snippet(
                publishedAt: "2024-01-01T00:00:00Z",
                channelId: "UC123456",
                title: "Sample Video",
                description: "This is a sample video description.",
                thumbnails: Thumbnails(
                    default: Thumbnail(url: "https://img.youtube.com/vi/dQw4w9WgXcQ/default.jpg", width: 120, height: 90),
                    medium: Thumbnail(url: "https://img.youtube.com/vi/dQw4w9WgXcQ/mqdefault.jpg", width: 320, height: 180),
                    high: Thumbnail(url: "https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg", width: 480, height: 360),
                    standard: nil,
                    maxres: nil
                ),
                channelTitle: "Sample Channel",
                tags: ["sample", "video"],
                categoryId: "10",
                liveBroadcastContent: "none",
                defaultLanguage: nil,
                localized: Localized(title: "Localized Sample Video", description: "Localized Description"),
                defaultAudioLanguage: nil
            ),
            contentDetails: ContentDetails(duration: "PT4M30S", dimension: "2d", definition: "hd", caption: "false", licensedContent: true, contentRating: ContentRating(), projection: "rectangular"),
            statistics: Statistics(viewCount: "1000", likeCount: "100", dislikeCount: nil, favoriteCount: nil, commentCount: "10")
        )]),
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
                  let videoIDsObservable: Observable<[String]> = owner.someVideoIDsObservable
                  let partObservable: Observable<String> = owner.somePartObservable

                  return Observable.combineLatest(videoIDsObservable, partObservable) { videoIDs, part in
                      return owner.fetchYoutube(videoIDs: videoIDs, part: part)
                  }
                  .flatMapLatest { $0 }
              }
            .asDriver(onErrorJustReturn: [])
            .drive(itemsRelay)
            .disposed(by: disposeBag)

        itemsRelay
            .asDriver(onErrorJustReturn: [])
             .drive(itemsRelay)
             .disposed(by: disposeBag)
    }
    
    func bind() {
        setupBindings()
        viewDidLoad.bind(to: fetchTrigger).disposed(by: disposeBag)
    }
    
    func fetchYoutube(videoIDs: [String], part: String) -> Observable<[DetailInfoSectionItem]> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            self.isLoading.accept(true)
            
            let id = videoIDs.joined(separator: ",")
            
            Task {
                do {
                    let domainVideos = try await self.youtubeUseCase.execute(id: id, part: part)
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
