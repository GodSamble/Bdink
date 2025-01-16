//
//  CategoryVideosViewController.swift
//  Buttwink
//
//  Created by 고영민 on 1/13/25.
//

import UIKit
import SnapKit
import Moya
import RxSwift
import RxCocoa

// MARK: - Section Data
enum DetailInfoSectionItem2: Hashable {
    case CategoryVideo([Int])
    
    public func getSectionLayoutKind2() -> SectionLayoutKind2 {
        switch self {
        case .CategoryVideo:
            return .categoryVideos
        }
    }
}

// MARK: - Item
enum SectionLayoutKind2: Int, CaseIterable, Hashable {
    case categoryVideos
}

final class CategoryVideosViewController: UIViewController, UICollectionViewDelegate {
    
    private var currentSnapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind2, DetailInfoSectionItem2>()
    private var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind2, DetailInfoSectionItem2>!
    var viewModel: CategoryVideosViewModel!
    private var disposeBag = DisposeBag()
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .buttwink_gray900
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CategoryVideoCell.self, forCellWithReuseIdentifier: CategoryVideoCell.identifier)
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    private func setLayout() {
        view.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setupDataSource()
        bindViewModel()
        
    }
    
    init(viewModel: CategoryVideosViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindViewModel() {
        viewModel.outputs.dataSource
            .bind(to: dataSourceBinder)
            .disposed(by: disposeBag)
        
        // 테스트용 데이터를 전달
        
        // dataSource가 바인딩된 이후에 데이터 확인
        viewModel.outputs.dataSource
            .subscribe(onNext: { data in
//                print("Data received in dataSource: \(data)")
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
    }
    
    var dataSourceBinder: Binder<[DetailInfoSectionItem2]> {
        return Binder(self) { view, data in
            // 스냅샷 초기화
            view.currentSnapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind2, DetailInfoSectionItem2>()
            
            // 섹션 추가
            SectionLayoutKind2.allCases.forEach { section in
                view.currentSnapshot.appendSections([section])
            }
            
            // 데이터 추가
            for item in data {
                let section = item.getSectionLayoutKind2()
                switch item {
                case .CategoryVideo(let images):
                    // CategoryVideo에 11개의 개별 아이템을 추가
                    let items = images.map { DetailInfoSectionItem2.CategoryVideo([$0]) }
                    view.currentSnapshot.appendItems(items, toSection: section)
                }
            }
            
            // 스냅샷 적용
            view.dataSource.apply(view.currentSnapshot, animatingDifferences: true)
        }
    }
    
    
    
    
    
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind2, DetailInfoSectionItem2>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                switch item {
                case .CategoryVideo(let images): // images 데이터를 받아옵니다.
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: CategoryVideoCell.identifier,
                        for: indexPath
                    ) as? CategoryVideoCell else {
                        return nil
                    }
                    return cell
                }
            }
        )
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = SectionLayoutKind2.allCases[safe: sectionIndex] else {
                return nil
            }
            switch sectionKind {
            case .categoryVideos:
                return self?.createCategoryVideoCellSection()
            }
        }
        return layout
    }
    
    
    private func createCategoryVideoCellSection() -> NSCollectionLayoutSection {
        // 1. 아이템 크기 설정
         let itemSize = NSCollectionLayoutSize(
             widthDimension: .fractionalWidth(0.5), // 각 아이템의 너비를 그룹의 절반으로 설정
             heightDimension: .absolute(220)        // 고정 높이 설정
         )
         let item = NSCollectionLayoutItem(layoutSize: itemSize)
         item.contentInsets = NSDirectionalEdgeInsets(//✅
             top: 0, leading: 17, bottom: 0, trailing: 17 // 아이템 간 간격 설정
         )

         // 2. 그룹 크기 설정 (2개의 아이템 포함)
         let groupSize = NSCollectionLayoutSize(
             widthDimension: .fractionalWidth(1.0), // 그룹 너비 = 섹션 너비
             heightDimension: .absolute(220)        // 고정 높이 설정
         )
         let group = NSCollectionLayoutGroup.horizontal(//✅
             layoutSize: groupSize,
             subitem: item,  // 동일한 아이템 사용
             count: 2        // 한 그룹에 2개의 아이템 배치
         )
        group.interItemSpacing = .fixed(-17) // 아이템 간 간격 10 설정

         // 3. 섹션 설정
         let section = NSCollectionLayoutSection(group: group)
         section.contentInsets = NSDirectionalEdgeInsets(
             top: 0, leading: 0, bottom: 0, trailing: 0 // 섹션의 여백 설정
         )
         section.interGroupSpacing = 38 // 그룹 간 간격 설정

         return section
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // currentSnapshot에서 해당 섹션에 대한 아이템 개수를 반환
        guard let sectionKind = SectionLayoutKind2(rawValue: section) else {
            return 0
        }
        
        return currentSnapshot.itemIdentifiers(inSection: sectionKind).count
    }
    
}
