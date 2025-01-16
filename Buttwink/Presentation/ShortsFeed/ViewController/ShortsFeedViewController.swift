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

// MARK: - Section Data
enum DetailInfoSectionItem: Hashable {
    case Tag([String])
    case Thumbnail([UIImage])
    case Third([UIImage])
    
    public func getSectionLayoutKind() -> SectionLayoutKind {
        switch self {
        case .Tag: return .tags
        case .Thumbnail: return .thumbnails
        case .Third: return .thirdSection
        }
    }
}
// MARK: - Item
enum SectionLayoutKind: Int, CaseIterable, Hashable {
    case tags, thumbnails, thirdSection
}

// MARK: - View Controller

final class ShortsFeedViewController: UIViewController, UICollectionViewDelegate, ViewModelBindableType, HeaderViewDelegate {
    
    let categoryViewModel = CategoryVideosViewModel()
    
    let sampleImages: [UIImage] = [
        UIImage.Icon.alarm_default!,
        UIImage.Icon.feed!,
        UIImage.Sample.sample1!
    ]
    let tagNames: [String] = ["NPC", "WNGP", "NABBA"]
    let thirdImages: [UIImage] = [
        UIImage.Icon.alarm_default!,
        UIImage.Icon.feed!,
        UIImage.Sample.sample1!
    ]

    
    var selectedTag: String? = nil
    var viewModel: ShortsFeedViewModel!
    var disposeBag = DisposeBag()
    
    
    // DiffableDataSource 관련 속성 초기화
    private var currentSnapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, DetailInfoSectionItem>()
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
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    convenience init() {
        let networkService = TestService()
        //        let boxOfficeMapper = DefaultMypageDataMapper()
        let repository = Repository_test(service: networkService
        )
        let fetchUseCase = UseCase_test(
            repositoryInterface: repository
        )
        let presentationMapper = DefaultMypagePresentationMapper()
        
        let viewModel = ShortsFeedViewModel(
            fetchUseCase: fetchUseCase,
            presentationMapper: presentationMapper
        )
        
        self.init(viewModel: viewModel)
    }
    
    init(viewModel: ShortsFeedViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setupDataSource()
        bindViewModel()
        viewModel.dataSource.accept(viewModel.dummyData) // 캐싱하는 방식 채택으로 성능 상승 & 사용자 입장에서, 처음에 데이터불러와지는 이질감 제거. // TODO: 스켈레톤 UI
        viewModel.inputs.viewDidLoad.accept(())
        updateSnapshot()
    }
    
    typealias Task = _Concurrency.Task
    
    func bindViewModel() {
        // DataSource 바인딩
        viewModel.outputs.dataSource
            .observe(on: MainScheduler.instance)
            .bind(to: dataSourceBinder)
            .disposed(by: disposeBag)
        
        // ViewDidLoad 이벤트 처리
        rx.viewWillAppear
            .take(1)
            .bind(to: viewModel.inputs.viewDidLoad)
            .disposed(by: disposeBag)
        
        // 에러 처리 (옵션으로 추가 가능)
        viewModel.outputs.error
            .subscribe(onNext: { [weak self] error in
            })
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Layout
    
    private func setLayout() {
        view.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Data Source
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, DetailInfoSectionItem>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                switch item {
                case .Tag( _):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: TagCell.identifier,
                        for: indexPath
                    ) as? TagCell else {
                        return nil
                    }
                    let dynamicCount = indexPath.row % self.sampleImages.count + 1
                    cell.configure(with: self.tagNames, with: dynamicCount)

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
                case .Thumbnail( _):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ThumbnailCell.identifier,
                        for: indexPath
                    ) as? ThumbnailCell else {
                        return nil
                    }
                    // indexPath.row를 기반으로 count 전달
                    let dynamicCount = indexPath.row % self.sampleImages.count + 1
                    cell.configure(with: self.sampleImages, with: dynamicCount)
                    self.viewModel.updateThumbnail(for: indexPath)
                    return cell
                case .Third(_):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ThirdCell.identifier,
                        for: indexPath
                    ) as? ThirdCell else {
                        return nil
                    }
                    let dynamicCount = indexPath.row % self.sampleImages.count + 1
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
            case .thumbnails:
                return self?.createThumbnailCellSection(withHeader: false)
            case .thirdSection:
                return self?.createThridSection(withHeader: true)
            }
        }
        return layout
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
            widthDimension: .estimated(270),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(2000),
            heightDimension: .estimated(356)
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
    
    private func createThridSection(withHeader: Bool) -> NSCollectionLayoutSection { // MARK: 정사각형✅
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(169),
            heightDimension: .estimated(169)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 13
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
    
    private func updateSnapshot() {
        currentSnapshot.deleteAllItems()
        currentSnapshot.appendSections(SectionLayoutKind.allCases)
        currentSnapshot.appendItems(viewModel.outputs.dataSource.value, toSection: .thumbnails)
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
    
    var dataSourceBinder: Binder<[DetailInfoSectionItem]> {
        return Binder(self) { view, data in
            // Snapshot 초기화
            view.currentSnapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, DetailInfoSectionItem>()
            
            // 모든 섹션 추가
            SectionLayoutKind.allCases.forEach { section in
                view.currentSnapshot.appendSections([section])
            }
            
            // 데이터 처리
            for item in data {
                let section = item.getSectionLayoutKind()
                var items: [DetailInfoSectionItem] = []
                
                // Section별 아이템 생성
                switch item {
                case .Tag(let tags):
                    items = tags.map { DetailInfoSectionItem.Tag([$0]) }
                case .Thumbnail(let images):
                    items = images.map { DetailInfoSectionItem.Thumbnail([$0]) }
                case .Third(let strings):
                    items = strings.map { DetailInfoSectionItem.Third([$0]) }
                }
                
                // 아이템을 섹션에 추가
                view.currentSnapshot.appendItems(items, toSection: section)
            }
            
            // Snapshot 적용
            view.dataSource.apply(view.currentSnapshot, animatingDifferences: true)
        }
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
