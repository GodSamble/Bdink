//
//  MypageViewController.swift
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
    case Tag([Int])
    case Thumbnail([UIImage])
    case Third([Double])
    
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
    
    var numberOfItemsInSection: Int {
        switch self {
        case .tags, .thirdSection:
            return 9
        case .thumbnails:
            return 3
        }
    }
}

// MARK: - View Controller

final class MypageViewController: UIViewController, UICollectionViewDelegate, ViewModelBindableType {
    
    var thumbnails: [UIImage?] = [
        UIImage.Sample.sample1 ?? UIImage(),
        UIImage.Sample.sample1 ?? UIImage()
    ]
    var thumbanil = ThumbnailCell()
    var viewModel: MypageViewModel!
    var disposeBag = DisposeBag()
    
    private var thumbnailImg: UIImage?
    //    private var thumbnailImgs: [UIImage?] = []
    var thumbnailImgs = [
        UIImage.Sample.sample1,
        UIImage.Sample.sample1,
        UIImage.Sample.sample1
    ]
    
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
        
        let viewModel = MypageViewModel(
            fetchUseCase: fetchUseCase,
            presentationMapper: presentationMapper
        )
        
        self.init(viewModel: viewModel)
    }
    
    init(viewModel: MypageViewModel) {
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
    }
    
    typealias Task = _Concurrency.Task
    
    func bindViewModel() {
        // DataSource 바인딩
        viewModel.outputs.dataSource
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
                case .Tag(let tagText):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: TagCell.identifier,
                        for: indexPath
                    ) as? TagCell else {
                        return nil
                    }
                    cell.configure(with: tagText.map{String($0)})
                    return cell
                case .Thumbnail(let thumbnail):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ThumbnailCell.identifier,
                        for: indexPath
                    ) as? ThumbnailCell else {
                        return nil
                    }
                    cell.configure(with: thumbnail, with: 3000)
                    return cell
                case .Third(_):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ThirdCell.identifier,
                        for: indexPath
                    ) as? ThirdCell else {
                        return nil
                    }
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
                return headerView
            }
            return nil
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionLayoutKind.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = SectionLayoutKind(rawValue: section) else {
            return 0
        }
        return section.numberOfItemsInSection
    }
    
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = SectionLayoutKind.allCases[safe: sectionIndex] else {
                return nil
            }
            switch sectionKind {
            case .tags:
                return self?.createTagCellSection(withHeader: false)
            case .thumbnails:
                return self?.createThumbnailCellSection(withHeader: true)
            case .thirdSection:
                return self?.createThridSection(withHeader: true)
            }
        }
        return layout
    }
    
    
    
    private func createTagCellSection(withHeader: Bool) -> NSCollectionLayoutSection { //✅
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(420),
            heightDimension: .estimated(30)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 4
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 22, bottom: 0, trailing: 22)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    private func createThumbnailCellSection(withHeader: Bool) -> NSCollectionLayoutSection { //✅
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(650),
            heightDimension: .estimated(356)
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
                                                    heightDimension: .estimated(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .top)
            section.boundarySupplementaryItems = [header]
        }
        
        return section
    }
    
    var dataSourceBinder: Binder<[DetailInfoSectionItem]> {
        return Binder(self) { view, data in
            view.currentSnapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, DetailInfoSectionItem>()
            
            SectionLayoutKind.allCases.forEach { section in
                view.currentSnapshot.appendSections([section])
            }
            
            for item in data {
                let section = item.getSectionLayoutKind()
                view.currentSnapshot.appendItems([item], toSection: section)
            }
            view.dataSource.apply(view.currentSnapshot, animatingDifferences: true)
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
