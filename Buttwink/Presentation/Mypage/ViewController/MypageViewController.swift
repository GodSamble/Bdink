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

enum DetailInfoSectionItem: Hashable {
    case thumbnail(String?) // URL이나 이미지 이름
    case tag(String?)
    case third(Double?)

    func getSectionLayoutKind() -> SectionLayoutKind {
        switch self {
        case .thumbnail:
            return .ThumbnailView
        case .tag:
            return .TagView
        case .third:
            return .ThirdView
        }
    }
}

enum SectionLayoutKind: Int, CaseIterable, Hashable {
    case ThumbnailView
    case TagView
    case ThirdView
}

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

        collectionView.register(ThumbnailView.self, forCellWithReuseIdentifier: ThumbnailView.identifier)
        collectionView.register(TagView.self, forCellWithReuseIdentifier: TagView.identifier)
        collectionView.register(ThirdView.self, forCellWithReuseIdentifier: ThirdView.identifier)

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
        configureDataSource()
        bindViewModel()
    }

    func bindViewModel() {
        let input = MypageViewModel.Input(viewDidLoad: rx.viewWillAppear.asObservable().take(1))
        let output = viewModel.transform(input: input)

        output.dataSource
            .bind(to: dataSourceBinder)
            .disposed(by: disposeBag)
    }

    private func setupLayout() {
        view.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, DetailInfoSectionItem>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                switch item {
                case .thumbnail(let imageName):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ThumbnailView.identifier,
                        for: indexPath
                    ) as? ThumbnailView else {
                        return nil
                    }
                    cell.bind(imageName ?? "default_image")
                    return cell

                case .tag(let tag):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ThumbnailView.identifier,
                        for: indexPath
                    ) as? ThumbnailView else {
                        return nil
                    }
                    cell.bind(tag ?? "default_image")
                    return cell

                case .third(let third):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ThirdView.identifier,
                        for: indexPath
                    ) as? ThirdView else {
                        return nil
                    }
                    cell.bind(third.map { "\($0)" } ?? "default_value")
                    return cell
                }
            }
        )
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let sectionKind = SectionLayoutKind.allCases[safe: sectionIndex] else {
                return nil
            }
            switch sectionKind {
            case .ThumbnailView:
                return self.createThumbnailViewSection()
            case .TagView:
                return self.createTagSection()
            case .ThirdView:
                return self.createThirdSection()
            }
        }
        return layout
    }

    private func createThumbnailViewSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

        return section
    }

    private func createTagSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

        return section
    }

    private func createThirdSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

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
            view.dataSource.apply(view.currentSnapshot, animatingDifferences: false)
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
