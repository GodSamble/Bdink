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


//MARK: Section Data = Model
enum DetailInfoSectionItem: Hashable {
    case Tag([String])
    case Thumbnail([UIImage]) // URL이나 이미지 이름
    case Third([Double])
    
    public func getSectionLayoutKind() -> SectionLayoutKind {
        switch self {
        case .Tag: return .Tag
        case .Thumbnail: return .Thumbnail
        case .Third: return .Third
        }
    }
}

//MARK: Item
enum SectionLayoutKind: Int, CaseIterable, Hashable {
    case Tag
    case Thumbnail
    case Third
}

// MARK: - View Controller

final class MypageViewController: UIViewController, UICollectionViewDelegate, ViewModelBindableType {
    
    var viewModel: MypageViewModel!
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
        collectionView.register(TagView.self, forCellWithReuseIdentifier: TagView.identifier)
        collectionView.register(ThumbnailView.self, forCellWithReuseIdentifier: ThumbnailView.identifier)
        collectionView.register(ThirdView.self, forCellWithReuseIdentifier: ThirdView.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        
        return collectionView
    }()
    
    init(viewModel: MypageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDataSource()
        bindViewModel()
        testWeatherAPI()
    }
      
    
    private func testWeatherAPI() {
        let testService = TestService()

        // 예시로 사용할 위도와 경도 값 (원하는 값으로 변경 가능)
        let latitude: Double = 44.34
        let longitude: Double = 10.99

        // API 호출
        testService.getTotalTest(lat: latitude, lon: longitude) { response in
            if let response = response {
                print("Weather Data: \(response)")
            } else {
                print("Failed to fetch data.")
            }
        }
    }
    
    
    func bindViewModel() {
        let input = MypageViewModel.Input(viewDidLoad: rx.viewWillAppear.asObservable().take(1))
        let output = viewModel.transform(input: input)

        output.dataSource
            .bind(to: dataSourceBinder)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
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
                case .Tag(let Tag):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: TagView.identifier,
                        for: indexPath
                    ) as? TagView else {
                        return nil
                    }
                    cell.configure(with: Tag)
                    return cell
                case .Thumbnail(let Thumbnail):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ThumbnailView.identifier,
                        for: indexPath
                    ) as? ThumbnailView else {
                        return nil
                    }
                    cell.configure(with: Thumbnail)
                    return cell
                case .Third(let Third):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ThirdView.identifier,
                        for: indexPath
                    ) as? ThirdView else {
                        return nil
                    }
//                    cell.configure(with: Third)
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
    
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let sectionKind = SectionLayoutKind.allCases[safe: sectionIndex] else {
                return nil
            }
            switch sectionKind {
            case .Tag:
                return self.createTagViewSection(withHeader: false)
            case .Thumbnail:
                return self.createThumbnailViewSection(withHeader: true)
            case .Third:
                return self.createThridSection(withHeader: true)
            }
        }
        return layout
    }
    
    private func createTagViewSection(withHeader: Bool) -> NSCollectionLayoutSection { //✅
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(271), // 가로로 텍스트 길이에 따른 변화니까.
            heightDimension: .estimated(33)
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
    
    private func createThumbnailViewSection(withHeader: Bool) -> NSCollectionLayoutSection { //✅
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(271),
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
            .map { _ in } // 메서드 호출 시 방출
    }
}
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
