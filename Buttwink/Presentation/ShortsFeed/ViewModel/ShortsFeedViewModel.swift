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
import SwiftUI

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

final class ShortsFeedViewModel: ShortsFeedViewModelType, ShortsFeedViewModelInput, ShortsFeedViewModelOutput, ObservableObject {
    private let outputObservable = PublishSubject<[DetailInfoSectionItem]>() // Define an output observable
    
    let selectedVideoURL = PublishSubject<String>()
    let thumbnailTapped = PublishRelay<String>()
    let videoIDsRelay = BehaviorRelay<[String]>(value: [])
    
    let videoURLRelay = PublishRelay<String>()
    
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
    @Published var items: Driver<[DetailInfoSectionItem]>
    
    // MARK: - Properties (UseCase/ Mapper)
    private let df = BehaviorRelay<[String]>(value: [])
    
    private let youtubeUseCase: FetchUnifiedYoutubeDataUseCase
    private let youtubeMapper: DetailInfoSectionMapper
    
    let disposeBag = DisposeBag()
    
    var somePartObservable: Observable<Int> {
        return Observable.just(20)
    }
    var someVideoIDsObservable: Observable<String> {
        return Observable.just("트포이")
    }
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    
    // MARK: - Dummy Data
    
    let dummyData: [DetailInfoSectionItem] = [
        .Tag(["TFE", "NABBA", "NPC"]),
        .Thumbnail([
            UnifiedYoutubeEntity(
                viewCount: "130",
                channelThumbnailUrl: "https://yt3.ggpht.com/ytc/AIf8zZTx2V7mLmR7N7zD.jpg", videoId: "X2EexM3_FRU",
                title: "백종원의 김치볶음밥 레시피",
                thumbnailUrl: "https://i.ytimg.com/vi/X2EexM3_FRU/default.jpg",
                channelId: "UCyn-K7rZLXjGl7VXGweIlcA",
                channelName: "백종원의 요리비책"
            )
        ]),
        .Thumbnail([
            UnifiedYoutubeEntity(
                viewCount: "150",
                channelThumbnailUrl: "https://yt3.ggpht.com/ytc/AAUvwng7UIfvh.jpg", videoId: "A8p4D5bYFvk",
                title: "초간단 감바스 알 아히요 레시피",
                thumbnailUrl: "https://i.ytimg.com/vi/A8p4D5bYFvk/default.jpg",
                channelId: "UCQhHdo6r_iHd0ZuG0a-UtMQ",
                channelName: "한세 HANSE"
            )
        ]),
        .Thumbnail([
            UnifiedYoutubeEntity(
                viewCount: "160",
                channelThumbnailUrl: "https://yt3.ggpht.com/ytc/AAUvwng9sd7df.jpg", videoId: "fOZndj8b5mk",
                title: "5분 완성 계란볶음밥 레시피",
                thumbnailUrl: "https://i.ytimg.com/vi/fOZndj8b5mk/default.jpg",
                channelId: "UCsU4-0Yxpjknz9udjP9OU0Q",
                channelName: "만개의레시피"
            )
        ]),
        .Third([UIImage.Icon.alarm_default!, UIImage.Icon.feed!, UIImage.Sample.sample1!]),
        .Lecture([UIImage.Icon.alarm_variant!, UIImage.Icon.info!, UIImage.Icon.kakao!])
    ]
    
    
    
    // MARK: - Initializer
    
    init(
        youtubeUseCase: FetchUnifiedYoutubeDataUseCase,
        youtubeMapper: DetailInfoSectionMapper
    ) {
        self.youtubeUseCase = youtubeUseCase
        self.youtubeMapper = youtubeMapper
        
        self.items = itemsRelay.asDriver()
        self.fetchTrigger = PublishSubject<Void>()
        self.itemsRelay.accept(dummyData)
        self.dataSource.accept(dummyData)
    }
    
    // MARK: - Binding
    
    private func setupBindings() {
        fetchTrigger
            .withUnretained(self)
            .flatMapLatest { owner, _ -> Observable<[DetailInfoSectionItem]> in
                let videoIDsObservable: Observable<String> = owner.someVideoIDsObservable
                let partObservable: Observable<Int> = owner.somePartObservable
                
                return Observable.combineLatest(videoIDsObservable, partObservable)
                    .flatMapLatest { query, maxResults in
                        return owner.fetchYoutube(query: query, maxResults: maxResults, videoPart: "snippet", channelPart: "snippet", ids: [])
                    }
            }
            .subscribe(onNext: { presentationVideos in
                print("Fetched videos: \(presentationVideos)")
            }, onError: { error in
                print("Error occurred: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    
    func bindThumbnailTap() {
        thumbnailTapped
            .asObservable()
            .subscribe(onNext: { [weak self] videoId in
                self?.selectedVideoURL.onNext(videoId)
            })
            .disposed(by: disposeBag)
    }
    
    func bind() {
        setupBindings()
        viewDidLoad.bind(to: fetchTrigger).disposed(by: disposeBag)
        bindThumbnailTap()
    }
    
    func fetchYoutube(query: String, maxResults: Int, videoPart: String, channelPart: String, ids: [String]) -> Observable<[DetailInfoSectionItem]> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            self.isLoading.accept(true)
            
            Task {
                do {
                    let domainVideos = try await self.youtubeUseCase.execute(
                        query: query,
                        maxResults: maxResults,
                        videoPart: videoPart,
                        channelPart: channelPart,
                        ids: ids
                    )
                    
                    let channelModels = domainVideos.map { channel in
                        Entity_YoutubeChannelData(channelThumbnailUrl: channel.thumbnailUrl)
                    }
                    
                    let videoModels = domainVideos.map { video in
                        Entity_YoutubeVideoData(viewCount: video.viewCount ?? "0")
                    }
                    
                    let searchModels = domainVideos.map { search in
                        Entity_YoutubeData(title: search.title, thumbnailUrl: search.thumbnailUrl, channelId: search.channelId, channelName: search.channelName)
                    }
                    
                    let presentationVideos = self.youtubeMapper.transform(searchModels: searchModels, channelModels: channelModels, videoModels: videoModels)
                    
                    DispatchQueue.main.async {
                        observer.onNext(presentationVideos) // Emit the transformed videos
                        self.dataSource.accept(presentationVideos) // Update the data source
                        observer.onCompleted() // Complete the observer
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.error.accept(error) // Notify UI of the error
                        observer.onError(error) // Pass error to observer
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    
    
    public func getVideoId(query: String, maxResults: Int, videoPart:String, channelPart:String, ids:[String]) -> Observable<[String]> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            self.isLoading.accept(true)
            
            Task {
                do {
                    let videos = try await self.youtubeUseCase.execute(query: query, maxResults: maxResults, videoPart: videoPart, channelPart: channelPart, ids: ids)
                    let videoIds = videos.compactMap { $0.videoId }
                    
                    self.videoIDsRelay.accept(videoIds)
                    
                    observer.onNext(videoIds)
                    observer.onCompleted()
                    self.isLoading.accept(false)
                } catch {
                    observer.onError(error)
                    self.error.accept(error)
                    self.isLoading.accept(false)
                }
            }
            return Disposables.create()
        }
    }
    
    func getVideoIDs() -> Observable<[String]> {
        return videoIDsRelay.asObservable()
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
