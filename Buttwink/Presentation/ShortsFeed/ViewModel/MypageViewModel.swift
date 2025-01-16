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

// MARK: - 상태 관리 구조체 ( 비동기 관련 )
//struct MypageState {
//    var isLoading: BehaviorRelay<Bool>
//    var currentPage: BehaviorRelay<Int>
//    var videos: BehaviorRelay<[Video]>
//}

// MARK: - Protocol Definitions

protocol ShortsFeedViewModelInput {
    var viewDidLoad: PublishRelay<Void> { get }
}

protocol ShortsFeedViewModelOutput {
    var dataSource: BehaviorRelay<[DetailInfoSectionItem]> { get }
    var error: PublishRelay<Error> { get }
}

protocol ShortsFeedViewModelType {
    var inputs: ShortsFeedViewModelInput { get }
    var outputs: ShortsFeedViewModelOutput { get }
}

// MARK: - ShortsFeedViewModel Implementation

final class ShortsFeedViewModel: ShortsFeedViewModelType, ShortsFeedViewModelInput, ShortsFeedViewModelOutput {
    
    // MARK: - Inputs & Outputs
    var inputs: ShortsFeedViewModelInput { return self }
    var outputs: ShortsFeedViewModelOutput { return self }
    
    // MARK: - Input
    let viewDidLoad = PublishRelay<Void>()
    
    // MARK: - Output
    let dataSource = BehaviorRelay<[DetailInfoSectionItem]>(value: [])
    let error = PublishRelay<Error>()
    
    // MARK: - State 관리
//    private let state = MypageState(
//        isLoading: BehaviorRelay<Bool>(value: false),
//        currentPage: BehaviorRelay<Int>(value: 1),
//        videos: BehaviorRelay<[Video]>(value: [])
//    )

    // MARK: - Properties
    private let fetchUseCase: UseCaseProtocol_test
    private let mapper: MypageMapper
    private let disposeBag = DisposeBag()
    var onVideosUpdated: (([Video]) -> Void)?
    
    // MARK: - Dummy Data
    let dummyData: [DetailInfoSectionItem] = [
        .Tag(["Asbf", "asd", "saf"]),
        .Thumbnail([
//            UIImage.Sample.sample1 ?? UIImage(),
//            UIImage.Sample.sample1 ?? UIImage()
        ]),
        .Third([])
    ]
    
    // MARK: - Initializer
    init(fetchUseCase: UseCaseProtocol_test, presentationMapper: MypageMapper) {
        self.fetchUseCase = fetchUseCase
        self.mapper = presentationMapper
        setupBindings() // 안전한 호출
    }
    
    
    // MARK: - Setup Bindings
    private func setupBindings() {
        viewDidLoad
            .flatMapLatest { [weak self] _ -> Observable<[DetailInfoSectionItem]> in
                guard let self = self else { return Observable.just([]) }
                return self.fetchData2()
                    .catch { [weak self] error in
                        self?.error.accept(error)
                        return .just([])
                    }
            }
            .bind(to: dataSource)
            .disposed(by: disposeBag)
    }
    
    
    internal func handleButtonTap(for buttonType: ButtonType) {
        switch buttonType {
        case .NPC:
            print("NPC button tapped")
        
        case .WNGP:
            print("WNGP button tapped")
            // Do something for WNGP button tap
        case .NABBA:
            print("NABBA button tapped")
            // Do something for NABBA button tap
        }
    }
    internal func updateThumbnail(for indexPath: IndexPath) {
        // Logic for updating the thumbnail at the given indexPath
        print("Update thumbnail for row \(indexPath.row)")
        // Example: You can update a thumbnail image or trigger some other UI update.
    }
    
    private func fetchData2() -> Observable<[DetailInfoSectionItem]> {
        // Sample 이미지 배열을 Thumbnail에 넣기
        let sampleImages: [UIImage] = [
            UIImage.Icon.apple!,
            UIImage.Icon.alarm_default!,
            UIImage.Sample.sample1!
        ]
        
        let tagNames: [String] = [
            "WNGP", "NABBA", "NPC"
        ]
        
        let thirdImages: [UIImage] = [
            UIImage.Icon.apple!,
            UIImage.Icon.alarm_default!,
            UIImage.Sample.sample1!
        ]
        
        return Observable.just([.Thumbnail(sampleImages), .Tag(tagNames), .Third(thirdImages)])
    }
    // MARK: - Fetch Data
//    private func fetchData() -> Observable<[DetailInfoSectionItem]> {
//        
//        Observable.create { [weak self] observer -> Disposable in
//            guard let self = self else {
//                observer.onCompleted()
//                return Disposables.create()
//            }
//
//            Task {
//                do {
//                    let entities = try await self.fetchUseCase.execute(lat: 4.0, lon: 4.0)
//                    let mappedData = self.mapper.transform(entities) // 매핑된 데이터
//                    print("Mapped data: \(mappedData)")
//                    let sectionItems: [DetailInfoSectionItem] = mappedData.flatMap { model in
//                        [
//                            .Tag([model.id]),
//                            .Thumbnail([UIImage.Sample.sample1 ?? UIImage()]),
//                            .Third([Double(model.audienceCount)])
//                        ]
//                    }
//                    observer.onNext(sectionItems) // 변환된 데이터 방출
//                    observer.onCompleted()
//                } catch {
//                    print("Error fetching data: \(error)")
//                    // 예외 발생 시 에러를 PublishRelay에 전달하고, dummyData를 사용
//                    self.error.accept(error)
//                    observer.onNext(self.dummyData) // 더미 데이터를 반환
//                    observer.onCompleted()
//                }
//            }
//
//            return Disposables.create()
//        }
//    }
    

}
