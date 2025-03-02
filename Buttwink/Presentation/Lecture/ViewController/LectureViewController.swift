//
//  LectureViewController.swift
//  Buttwink
//
//  Created by 고영민 on 2/22/25.
//

import UIKit
import RxSwift
import SnapKit
import Moya

final class LectureViewController: UIViewController, UICollectionViewDelegate, LectureHeaderViewDelegate {
    func didTapHeaderButton() {
        //        let categoryVC = CategoryVideosViewController(viewModel: categoryViewModel)
        //        navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        setLayout()
        collectionView.dataSource = dataSource
        setupDummyData()
        updateLectureContents()
        //        bindViewModel()
    }
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    //    private var viewModel: LectureViewModel
    //    var disposeBag: DisposeBag = DisposeBag()
    private func setupDummyData() {
        let sampleData: [SectionItem_Lecture] = [
            .Head([
                Head(
                    thumbnail: UIImage(),
                    title: "iOS 앱 개발 마스터 코스",
                    bookmarkNum: 250,
                    kindOfLecture: "10시 10분",
                    chapterNum: 15,
                    runningTime: "5시간 30분"
                )
            ]),
            .Purchase([
                Purchase(
                    normalPrice: 200000,
                    discountPrice: 149000,
                    discoutPercent: 25
                )
            ]),
            .Review([
                Review(
                    reviewContent: "강의가 정말 이해하기 쉬웠어요! 추천합니다.",
                    nickName: "코딩초보"
                ),
                Review(
                    reviewContent: "예제 코드가 많아서 따라하기 좋네요.",
                    nickName: "SwiftMaster"
                ),
                Review(
                    reviewContent: "ㅇㄹ.",
                    nickName: "ㅁㄴㅇㄹ"
                ),
                Review(
                    reviewContent: "ㄴㅇㄹ.",
                    nickName: "ㄴㅇㄹㅎ"
                ),
                Review(
                    reviewContent: "지두.",
                    nickName: "미낭ㅎ"
                ),
                Review(
                    reviewContent: "니ㅏㅜㅎ.",
                    nickName: "피ㅏㅜㄴ"
                ),
                Review(
                    reviewContent: "ㅣㄷㅈ라ㅡ.",
                    nickName: "ㄴㅇㄹ"
                ),
                Review(
                    reviewContent: "ㄴㅇ리ㅏ.",
                    nickName: "ㅈ디루"
                )
            ]),
            .CurriCulum([
                Curriculum(
                    learningDate: Date(),
                    lectureNum: 1,
                    leaningTime: 45,
                    detailChapter: "Swift 기본 문법",
                    detailContent: "변수, 상수, 연산자, 제어문 학습",
                    detailLearningTime: "45분"
                ),
                Curriculum(
                    learningDate: Date(),
                    lectureNum: 2,
                    leaningTime: 60,
                    detailChapter: "UIKit을 활용한 UI 개발",
                    detailContent: "Storyboard와 코드로 UI 구성하기",
                    detailLearningTime: "1시간"
                ),
                Curriculum(
                    learningDate: Date(),
                    lectureNum: 3,
                    leaningTime: 60,
                    detailChapter: "UIKit을 활용한 UI 개발",
                    detailContent: "Storyboard와 코드로 UI 구성하기",
                    detailLearningTime: "1시간"
                ),
                Curriculum(
                    learningDate: Date(),
                    lectureNum: 4,
                    leaningTime: 60,
                    detailChapter: "UIKit을 활용한 UI 개발",
                    detailContent: "Storyboard와 코드로 UI 구성하기",
                    detailLearningTime: "1시간"
                )
            ])
        ]
        updateSnapshot(with: sampleData)
    }
    
    
    
    private var currentSnapshot: NSDiffableDataSourceSnapshot<SectionLayoutKind_Lecture, SectionItem_Lecture> = NSDiffableDataSourceSnapshot()
    
    private var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind_Lecture, SectionItem_Lecture>!
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(HeadCell.self, forCellWithReuseIdentifier: HeadCell.identifier)
        collectionView.register(PurchaseCell.self, forCellWithReuseIdentifier: PurchaseCell.identifier)
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: ReviewCell.identifier)
        collectionView.register(CurriculumCell.self, forCellWithReuseIdentifier: CurriculumCell.identifier)
        collectionView.register(LectureHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LectureHeaderView.identifier)
        collectionView.register(LectureFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LectureFooterCell.identifier)
        
        return collectionView
    }()
    
    //    private func bindViewModel() {
    //          viewModel.lectureContents
    //              .observe(on: MainScheduler.instance)
    //              .subscribe(onNext: { [weak self] data in
    //                  self?.updateSnapshot(with: data)
    //              })
    //              .disposed(by: disposeBag)
    //      }
    
    private func setLayout() {
        view.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        setupDataSource()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionKind = SectionLayoutKind_Lecture(rawValue: section) else {
            return 0
        }
        
        return currentSnapshot.itemIdentifiers(inSection: sectionKind).count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: LectureHeaderView.identifier,
            for: indexPath
        ) as! LectureHeaderView
        
        let sectionKind = SectionLayoutKind_Lecture.allCases[safe: indexPath.section]
        
        
        return headerView
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = SectionLayoutKind_Lecture.allCases[safe: sectionIndex] else {return nil}
            
            switch sectionKind {
            case .head:
                return self?.createHeadCellSection()
            case .purchase:
                return self?.createPurchaseCellSection()
            case .review:
                return self?.createReviewSection()
            case .curriculum:
                return self?.createCurriculumSection(for: 2)
            }
        }
        return layout
    }
    
    private func createHeadCellSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),  // ✅ 컬렉션 뷰의 전체 너비 사용
            heightDimension: .estimated(500)       // ✅ 가변 높이
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0), // ✅ 너비를 맞춤
            heightDimension: .estimated(500)       // ✅ 높이를 유동적으로 설정
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
    
    private func createPurchaseCellSection() -> NSCollectionLayoutSection { //✅
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(190)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(190)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        
        //        if withHeader {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]
        //        }
        
        
        return section
    }
    
    
    private func createReviewSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(167), // 각 아이템 가로 크기 200
            heightDimension: .absolute(137) // 각 아이템 세로 크기 200
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 가로 4개 배치 (한 줄에 4개)
        let horizontalGroupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(200 * 4 + 10 * 3), // 4개 배치 + 간격
            heightDimension: .absolute(137) // 높이는 고정
        )
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: horizontalGroupSize,
            subitem: item,
            count: 4
        )
        horizontalGroup.interItemSpacing = .fixed(8)
        
        // 세로 2줄 배치 (총 8개)
        let verticalGroupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(200 * 4 + 10 * 3), // 가로 4개 크기 유지
            heightDimension: .absolute(137 * 2 + 10) // 2줄 크기 유지
        )
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: verticalGroupSize,
            subitem: horizontalGroup,
            count: 2 // 2줄 배치
        )
        verticalGroup.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        // 🔥 수평 스크롤 가능하게 설정
        section.orthogonalScrollingBehavior = .continuous
        
        //        if withHeader {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]
        //        }
        
        
        return section
    }
    
    
    
    
    
    private func createCurriculumSection(for index: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50) // 🔥 높이 유동적으로 변경
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50) // 🔥 아이템 개수에 따라 달라짐
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        
        //        if withHeader {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]
        //        }
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50) // 푸터 높이 조절 가능
        )
        let footerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        section.boundarySupplementaryItems.append(footerItem)
        
        
        return section
    }
    
    private func updateSnapshot() {
        // 현재 스냅샷을 업데이트하는 부분
        currentSnapshot.deleteAllItems()
        currentSnapshot.appendSections([.head, .purchase, .review, .curriculum])  // 섹션 추가
        
        // 각 섹션에 맞는 아이템을 추가
        let sampleData: [SectionItem_Lecture] = [
            .Head([Head(thumbnail: UIImage(), title: "iOS 앱 개발 마스터 코스", bookmarkNum: 250, kindOfLecture: "10시 10분", chapterNum: 15, runningTime: "5시간 30분")]),
            .Purchase([Purchase(normalPrice: 200000, discountPrice: 149000, discoutPercent: 25)]),
            .Review([
                Review(reviewContent: "강의가 정말 이해하기 쉬웠어요! 추천합니다.", nickName: "코딩초보"),
                Review(reviewContent: "예제 코드가 많아서 따라하기 좋네요.", nickName: "SwiftMaster")
            ]),
            .CurriCulum([
                Curriculum(learningDate: Date(), lectureNum: 1, leaningTime: 45, detailChapter: "Swift 기본 문법", detailContent: "변수, 상수, 연산자, 제어문 학습", detailLearningTime: "45분"),
                Curriculum(learningDate: Date(), lectureNum: 2, leaningTime: 45, detailChapter: "Swift 기본 문법", detailContent: "변수, 상수, 연산자, 제어문 학습", detailLearningTime: "45분"),
                Curriculum(learningDate: Date(), lectureNum: 3, leaningTime: 45, detailChapter: "Swift 기본 문법", detailContent: "변수, 상수, 연산자, 제어문 학습", detailLearningTime: "45분"),
                Curriculum(learningDate: Date(), lectureNum: 4, leaningTime: 45, detailChapter: "Swift 기본 문법", detailContent: "변수, 상수, 연산자, 제어문 학습", detailLearningTime: "45분")
            ])
        ]
        
        currentSnapshot.appendItems(sampleData)
        
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
    
    
    private func updateSnapshot(with data: [SectionItem_Lecture]) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind_Lecture, SectionItem_Lecture>()
        snapshot.appendSections(SectionLayoutKind_Lecture.allCases)
        
        var uniqueItems = Set<SectionItem_Lecture>() // 중복 제거를 위한 Set
        
        for item in data {
            let section = item.getSectionLayoutKind()
            
            var items: [SectionItem_Lecture] = []
            
            switch item {
            case .Head(let tags):
                items = tags.map { SectionItem_Lecture.Head([$0]) } // ✅ 개별 아이템으로 분리
            case .Purchase(let videoItem):
                items = videoItem.map { SectionItem_Lecture.Purchase([$0]) } // ✅ 개별 썸네일 분리
            case .Review(let strings):
                items = strings.map { SectionItem_Lecture.Review([$0]) } // ✅ 개별 문자열 분리
            case .CurriCulum(let strings):
                items = strings.map { SectionItem_Lecture.CurriCulum([$0])}
            }
            uniqueItems.formUnion(items)
        }
        
        for section in SectionLayoutKind_Lecture.allCases {
            let filteredItems = Array(uniqueItems).filter { $0.getSectionLayoutKind() == section }
            snapshot.appendItems(filteredItems, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
    
    
    func updateLectureContents() {
        var snapshot = dataSource.snapshot() // 🔥 현재 스냅샷 가져오기
        snapshot.reloadItems(snapshot.itemIdentifiers) // 🔥 아이템 업데이트
        dataSource.apply(snapshot, animatingDifferences: true) // 🔥 변경사항 적용
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind_Lecture, SectionItem_Lecture>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                switch item {
                    
                    
                    
                case .Head(let data):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: HeadCell.identifier,
                        for: indexPath
                    ) as? HeadCell else {
                        return nil
                    }
                    
                    
                    
                    return cell
                    
                case .Purchase(let data):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: PurchaseCell.identifier,
                        for: indexPath
                    ) as? PurchaseCell else {
                        return UICollectionViewCell()
                    }
                    
                    
                    return cell
                    
                case .Review(_):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ReviewCell.identifier,
                        for: indexPath
                    ) as? ReviewCell else {
                        return nil
                    }
                    
                    return cell
                case .CurriCulum(_):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: CurriculumCell.identifier,
                        for: indexPath
                    ) as? CurriculumCell else {
                        return nil
                    }
                    
                    switch indexPath.item {
                    case 0:
                        cell.configure(title: "운동 소개", contents: [], isImageSection: true)
                    case 1:
                        cell.configure(title: "목차 1", contents: ["스트레칭", "스쿼트", "런지"], isImageSection: false)
                    case 2:
                        cell.configure(title: "목차 2", contents: ["데드리프트", "벤치프레스", "푸쉬업"], isImageSection: false)
                    case 3:
                        cell.configure(title: "목차 3", contents: ["데드리프트", "벤치프레스", "푸쉬업"], isImageSection: false)
                    default:
                        break
                    }
                    
                    return cell
                }
            }
        )
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: LectureHeaderView.identifier,
                    for: indexPath
                ) as? LectureHeaderView else {
                    return nil
                }
                
                switch indexPath.section{
                case 1: headerView.configure(headerType: .one, delegate: nil)
                case 2: headerView.configure(headerType: .two, delegate: self)
                case 3: headerView.configure(headerType: .three, delegate: nil)
                default:
                    headerView.configure(headerType: .one, delegate: nil)
                }
                
                headerView.delegate = self
                return headerView
            }
            // ✅ Footer 추가
            if kind == UICollectionView.elementKindSectionFooter {
                guard let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: LectureFooterCell.identifier,
                    for: indexPath
                ) as? LectureFooterCell else {
                    return UICollectionReusableView()
                }
                
                return footer
            }
            return nil
        }
    }
}
