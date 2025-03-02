//
//  ShortsFeedViewController.swift
//  Buttwink
//
//  Created by 고영민 on 11/26/24.
//

import UIKit
import DesignSystem
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
import Moya
import YouTubePlayerKit
import SwiftUI

final class ShortsFeedViewController: UIViewController, UICollectionViewDelegate, ViewModelBindableType, HeaderViewDelegate {
    
    // MARK: - Property
    
    let itemsSet: Set<DetailInfoSectionItem> = [
        .Tag(["Swift"]),
        .Thumbnail([]),
        .Third([UIImage()]),
        .Lecture([UIImage()])
    ]
    
    // 예를 들어, Thumbnail 타입만 필터링
    var filteredItems: [DetailInfoSectionItem] {
        itemsSet.filter {
            switch $0 {
            case .Thumbnail, .Tag, .Third, .Lecture:
                return true
            default:
                return false
            }
            
        }
    }
    
    private let selectedVideoURL = PublishRelay<String>()
    
    var uniqueItems: Set<DetailInfoSectionItem> = []
    let categoryViewModel = CategoryVideosViewModel()
    //    let tagNames: [String] = ["NPC", "WNGP", "NABBA"]
    let thirdImages: [UIImage] = [
        UIImage.Icon.alarm_default!,
        UIImage.Icon.feed!,
        UIImage.Sample.sample1!
    ]
    
    var selectedTag: String? = nil
    var viewModel: ShortsFeedViewModel!
    var disposeBag = DisposeBag()
    
    private var currentSnapshot: NSDiffableDataSourceSnapshot<SectionLayoutKind, DetailInfoSectionItem> = NSDiffableDataSourceSnapshot()
    
    private let snapshotRelay = BehaviorRelay<NSDiffableDataSourceSnapshot<SectionLayoutKind, DetailInfoSectionItem>>(value: NSDiffableDataSourceSnapshot())
    
    private var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, DetailInfoSectionItem>!
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        collectionView.register(ThumbnailCell.self, forCellWithReuseIdentifier: ThumbnailCell.identifier)
        collectionView.register(ThirdCell.self, forCellWithReuseIdentifier: ThirdCell.identifier)
        collectionView.register(LectureCell.self, forCellWithReuseIdentifier: LectureCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    // MARK: - Init
    
    convenience init() {
        let networkService = DefaultYoutubeNetworkService()
        let youtubeMapper = DetailInfoSectionMapperImpl()
        
        let repository = Repository_Youtube(networkService: networkService, mapper: youtubeMapper as! Mappers_YoutubeData)
        let youtubeUseCase = FetchUnifiedYoutubeDataUseCaseImpl(repositoryInterface_Youtube: repository)
        let youtubePresentationMapper = DetailInfoSectionMapperImpl()
        let viewModel = ShortsFeedViewModel(
            youtubeUseCase: youtubeUseCase,
            youtubeMapper: youtubePresentationMapper
        )
        self.init(viewModel: viewModel)
        
    }
    
    init(viewModel: ShortsFeedViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - LifeCycle
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setupDataSource()
        bindViewModel()
        if let youtubeAPIKey = Bundle.main.object(forInfoDictionaryKey: "YOUTUBE_API_KEY") as? String {
            // API 키를 사용하여 서버 통신 수행
            print("API Key: \(youtubeAPIKey)")
        } else {
            print("API 키가 설정되지 않았습니다.")
        }
        
        if let apiKey = ProcessInfo.processInfo.environment["YOUTUBE_API_KEY"] {
            print("API Key Loaded: \(apiKey)")
        } else {
            print("API Key Not Found!")
        }
        
        // 초기 더미 데이터로 캐시된 데이터 로드 (빠르게 UI 렌더링)
        //        viewModel.dataSource.accept(viewModel.dummyData)
        fetchNewData()
        //        viewModel.inputs.viewDidLoad.accept(())
        //        viewModel.bind()
        
        // 기본 스냅샷 업데이트 (기존 데이터로 UI 초기화)
        updateSnapshot(with: viewModel.dummyData)
        
        // 비동기적으로 새로운 데이터를 받아온 후 업데이트
        
        // ✅ 선택된 URL을 구독하여 화면 전환
        selectedVideoURL
            .subscribe(onNext: { [weak self] videoURL in
                self?.navigateToVideoPlayer(with: videoURL)
            })
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Binding & Network
    
    func fetchNewData() {
        let query = "트포이"
        let maxResults = 5
        let videoPart = "snippet,statistics,contentDetails" // 비디오 데이터 상세 정보 포함
        let ids = ["S3KEgDlkxC8", "dQw4w9WgXcQ"] // 특정 비디오 ID
        let channelPart = "snippet,statistics" // 채널 정보 포함
        
        //        viewModel.fetchYoutube(videoIDs: videoIDs, part: part)
        viewModel.fetchYoutube(query: query, maxResults: maxResults, videoPart: videoPart, channelPart: channelPart, ids: ids)
            .subscribe(onNext: { [weak self] newData in
                self?.updateSnapshot(with: newData)
            })
            .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        
        viewModel.snapshotRelay
            .observe(on: MainScheduler.instance)
            .bind { [weak self] snapshot in
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.dataSource
            .filter { !$0.isEmpty } // ✅ 비어 있으면 이벤트 방지
            .take(1) // ✅ 처음 한 번만 실행되도록 제한
            .subscribe(onNext: { _ in
                print("✅ DataSource 업데이트 완료")
            })
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .take(1)
            .bind(to: viewModel.inputs.viewDidLoad)
            .disposed(by: disposeBag)
        
        viewModel.outputs.error
            .subscribe(onNext: { [weak self] error in
            })
            .disposed(by: disposeBag)
        
        //        collectionView.rx.itemSelected
        //            .subscribe(onNext: { [weak self] indexPath in
        //                guard let self = self else { return }
        //                let dataSource = self.viewModel.outputs.dataSource.value
        //
        //                if dataSource.isEmpty {
        //                            print("🚨 데이터가 아직 로드되지 않음! indexPath: \(indexPath)")
        //                            return
        //                        }
        //
        //                guard indexPath.item < dataSource.count else {
        //                            print("❌ Index out of range: \(indexPath.item), available: \(dataSource.count)")
        //                            return
        //                        }
        //                let item = dataSource[indexPath.item]
        //                       if case let .Thumbnail(thumbnails) = item, let firstThumbnail = thumbnails.first {
        //                           print("✅ Thumbnail tapped: \(firstThumbnail.videoId)")
        //                           self.viewModel.thumbnailTapped.accept(firstThumbnail.videoId!)
        //                       }
        //            })
        //            .disposed(by: disposeBag)
        
        viewModel.thumbnailTapped
            .subscribe(onNext: { [weak self] videoId in
                self?.openYoutube(videoId: videoId)
            })
            .disposed(by: disposeBag)
    }
    
    private func openYoutube(videoId: String) {
        let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(videoId)")!
        UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
    }
    
    var dataSourceBinder: Binder<[DetailInfoSectionItem]> {
        return Binder(self) { view, data in
            var currentSnapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, DetailInfoSectionItem>()
            
            SectionLayoutKind.allCases.forEach { section in
                currentSnapshot.appendSections([section])
            }
            
            for item in data {
                let section = item.getSectionLayoutKind()
                var items: [DetailInfoSectionItem] = []
                
                // Section별 아이템 생성
                switch item {
                case .Tag(let tags):
                    items = tags.map { DetailInfoSectionItem.Tag([$0]) }
                case .Thumbnail(let images):
                    items = images.map { DetailInfoSectionItem.Thumbnail([$0])}
                case .Third(let strings):
                    items = strings.map { DetailInfoSectionItem.Third([$0]) }
                case .Lecture(let strings):
                    items = strings.map {
                        DetailInfoSectionItem.Lecture([$0])
                    }
                }
                currentSnapshot.appendItems(items, toSection: section)
            }
            view.dataSource.apply(currentSnapshot, animatingDifferences: true)
        }
    }
    
    
    // MARK: - Data Source
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, DetailInfoSectionItem>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                switch item {
                case .Tag(let data):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: TagCell.identifier,
                        for: indexPath
                    ) as? TagCell else {
                        return nil
                    }
                    let dynamicCount = indexPath.row % self.viewModel.dummyData.count + 1
                    cell.configure(with: data, with: dynamicCount)
                    
                    cell.buttonTapSubject
                        .observe(on: MainScheduler.instance)
                        .subscribe(onNext: { [weak self] buttonType in
                            guard let self = self else { return }
                            
                            switch buttonType {
                            case .NPC:
                                self.viewModel.handleButtonTap(for: .NPC)
                            case .WNGP:
                                self.viewModel.handleButtonTap(for: .WNGP)
                            case .NABBA:
                                self.viewModel.handleButtonTap(for: .NABBA)
                            }
                        })
                        .disposed(by: cell.disposeBag)
                    return cell
                    
                case .Thumbnail(let data):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ThumbnailCell.identifier,
                        for: indexPath
                    ) as? ThumbnailCell else {
                        return UICollectionViewCell()
                    }
                    let dynamicCount = indexPath.row % self.viewModel.dummyData.count + 1
                    if !data.isEmpty {
                        cell.configure(with: data)
                        cell.thumbnailTapped
                            .bind(to: self.selectedVideoURL)
                            .disposed(by: cell.disposeBag)
                    } else {
                        return UICollectionViewCell()
                    }
                    
                    return cell
                    
                case .Third(_):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ThirdCell.identifier,
                        for: indexPath
                    ) as? ThirdCell else {
                        return nil
                    }
                    let dynamicCount = indexPath.row % self.viewModel.dummyData.count + 1
                    cell.configure(with: self.thirdImages, with: dynamicCount)
                    return cell
                case .Lecture(_):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: LectureCell.identifier,
                        for: indexPath
                    ) as? LectureCell else {
                        return nil
                    }
                    let dynamicCount = indexPath.row % self.viewModel.dummyData.count + 1
                    cell.configure(with: self.thirdImages, with: dynamicCount)
                    return cell
                }
            }
        )
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HeaderView.identifier,
                    for: indexPath
                ) as? HeaderView else {
                    return nil
                }
                headerView.delegate = self
                return headerView
            }
            return nil
        }
    }
    
    // MARK: - Snapshot
    
    private func updateSnapshot(with data: [DetailInfoSectionItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, DetailInfoSectionItem>()
        snapshot.appendSections(SectionLayoutKind.allCases)
        
        var uniqueItems = Set<DetailInfoSectionItem>() // 중복 제거를 위한 Set
        
        for item in data {
            let section = item.getSectionLayoutKind()
            
            var items: [DetailInfoSectionItem] = []
            
            switch item {
            case .Tag(let tags):
                items = tags.map { DetailInfoSectionItem.Tag([$0]) } // ✅ 개별 아이템으로 분리
            case .Thumbnail(let videoItem):
                items = videoItem.map { DetailInfoSectionItem.Thumbnail([$0]) } // ✅ 개별 썸네일 분리
            case .Third(let strings):
                items = strings.map { DetailInfoSectionItem.Third([$0]) } // ✅ 개별 문자열 분리
            case .Lecture(let strings):
                items = strings.map { DetailInfoSectionItem.Lecture([$0])}
            }
            uniqueItems.formUnion(items)
            //            snapshot.appendItems(items, toSection: section)
        }
        
        for section in SectionLayoutKind.allCases {
            let filteredItems = Array(uniqueItems).filter { $0.getSectionLayoutKind() == section }
            snapshot.appendItems(filteredItems, toSection: section)
        }
        
        //        snapshotRelay.accept(snapshot)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - CompositionalLayout
    
    private func setLayout() {
        view.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionKind = SectionLayoutKind(rawValue: section) else {
            return 0
        }
        
        return currentSnapshot.itemIdentifiers(inSection: sectionKind).count
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = SectionLayoutKind.allCases[safe: sectionIndex] else {return nil}
            
            switch sectionKind {
            case .tags:
                return self?.createTagCellSection(withHeader: false)
            case .videoItem:
                return self?.createThumbnailCellSection(withHeader: false)
            case .thirdSection:
                return self?.createThridSection(withHeader: true)
            case .lecture:
                return self?.createLectureSection(withHeader: true)
            }
        }
        return layout
    }
    
    func updateSnapshotWithItems() {
        // 현재 스냅샷에 .thumbnails 섹션이 존재하는지 확인
        if currentSnapshot.sectionIdentifiers.contains(.tags) == false {
            // 섹션이 없으면 섹션을 추가
            currentSnapshot.appendSections([.tags])
        }
        // 현재 스냅샷에 .thumbnails 섹션이 존재하는지 확인
        if currentSnapshot.sectionIdentifiers.contains(.videoItem) == false {
            // 섹션이 없으면 섹션을 추가
            currentSnapshot.appendSections([.videoItem])
        }
        
        // .third 섹션에 대해서는 헤더를 추가하고, 항목을 추가하는 방식으로 처리
        if currentSnapshot.sectionIdentifiers.contains(.thirdSection) == false {
            // 섹션 추가
            currentSnapshot.appendSections([.thirdSection])
        }
        
        if currentSnapshot.sectionIdentifiers.contains(.lecture) == false {
            currentSnapshot.appendSections([.lecture])
        }
        
        currentSnapshot.appendItems(viewModel.outputs.dataSource.value, toSection: .tags)
        // .third 섹션에 헤더가 추가되는 경우, 헤더를 true로 설정 (헤더가 추가되도록)
        currentSnapshot.appendItems(viewModel.outputs.dataSource.value, toSection: .thirdSection)
        
        // .thumbnails 섹션에 아이템을 추가하는 방식
        currentSnapshot.appendItems(viewModel.outputs.dataSource.value, toSection: .videoItem)
        
        currentSnapshot.appendItems(viewModel.outputs.dataSource.value, toSection: .lecture)
        
        // 변경된 스냅샷을 데이터 소스에 적용
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
    
    private func createTagCellSection(withHeader: Bool) -> NSCollectionLayoutSection { //✅
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(80),
            heightDimension: .estimated(33)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(33)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 22, bottom: 7, trailing: 0)
        section.boundarySupplementaryItems = []
        section.orthogonalScrollingBehavior = .none
        
        return section
    }
    
    private func createThumbnailCellSection(withHeader: Bool) -> NSCollectionLayoutSection { //✅
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(141),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(1500),
            heightDimension: .estimated(188)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 22, bottom: 30, trailing: 22)
        section.orthogonalScrollingBehavior = .continuous
        
        if withHeader {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .top)
            section.boundarySupplementaryItems = [header]
        }
        
        return section
    }
    
    private func createThridSection(withHeader: Bool) -> NSCollectionLayoutSection { // ✅
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(155),
            heightDimension: .estimated(110+85+30) // +5 + 30(리뷰수추가)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 22, bottom: 0, trailing: 22)
        section.orthogonalScrollingBehavior = .continuous
        
        if withHeader {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(40))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .top)
            section.boundarySupplementaryItems = [header]
        }
        
        return section
    }
    private func createLectureSection(withHeader: Bool) -> NSCollectionLayoutSection { // ✅
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(155),
            heightDimension: .estimated(110+85+30) // +5 + 30(리뷰수추가)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 22, bottom: 0, trailing: 22)
        section.orthogonalScrollingBehavior = .continuous
        
        if withHeader {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(40))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .top)
            section.boundarySupplementaryItems = [header]
        }
        
        return section
    }
    // MARK: 화면전환(w.델리게이트)
    
    func didTapHeaderButton() {
        let categoryVC = CategoryVideosViewController(viewModel: categoryViewModel)
        navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    func getButtonType(from buttonName: String) -> ButtonType {
        if buttonName.contains("WNGP") {
            return .WNGP
        } else if buttonName.contains("NPC") {
            return .NPC
        } else {
            return .NABBA
        }
    }
    
    private func navigateToVideoPlayer(with videoURL: String) {
        let videoPlayerView = ContentView(selectedVideo: videoURL)
        let hostingController = UIHostingController(rootView: videoPlayerView)
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
}

extension Reactive where Base: UIViewController {
    var viewWillAppear: Observable<Void> {
        return methodInvoked(#selector(Base.viewWillAppear))
            .map { _ in }
    }
}
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
