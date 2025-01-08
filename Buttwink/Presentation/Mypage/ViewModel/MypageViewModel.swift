//
//  MypageViewModel.swift
//  Buttwink
//
//  Created by 고영민 on 11/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import DesignSystem

// MARK: - Protocol Definitions

protocol MypageViewModelInput {
    var viewDidLoad: PublishRelay<Void> { get }
}

protocol MypageViewModelOutput {
    var dataSource: BehaviorRelay<[DetailInfoSectionItem]> { get }
    var error: PublishRelay<Error> { get }
}

protocol MypageViewModelType {
    var inputs: MypageViewModelInput { get }
    var outputs: MypageViewModelOutput { get }
}

// MARK: - MypageViewModel Implementation

final class MypageViewModel: MypageViewModelType, MypageViewModelInput, MypageViewModelOutput {
    
    // MARK: - Inputs & Outputs
    var inputs: MypageViewModelInput { return self }
    var outputs: MypageViewModelOutput { return self }
    
    // MARK: - Input
    let viewDidLoad = PublishRelay<Void>()
    
    // MARK: - Output
    let dataSource = BehaviorRelay<[DetailInfoSectionItem]>(value: [])
    let error = PublishRelay<Error>()
    
    // MARK: - Properties
    private let fetchUseCase: UseCaseProtocol_test
    private let mapper: MypageMapper
    private let disposeBag = DisposeBag()
    
    // MARK: - Dummy Data
    let dummyData: [DetailInfoSectionItem] = [
        .Tag([1, 2, 3]),
        .Thumbnail([
            UIImage.Sample.sample1 ?? UIImage(),
            UIImage.Sample.sample1 ?? UIImage()
        ]),
        .Third([30.0, 22.0, 35.0])
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
                return self.fetchData()
                    .catch { [weak self] error in
                        self?.error.accept(error)
                        return .just(self?.dummyData ?? []) //⭐️
                    }
            }
            .bind(to: dataSource)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Fetch Data
    private func fetchData() -> Observable<[DetailInfoSectionItem]> {
        
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }

            Task {
                do {
                    let entities = try await self.fetchUseCase.execute(lat: 4.0, lon: 4.0)
                    let mappedData = self.mapper.transform(entities) // 매핑된 데이터
                    print("Mapped data: \(mappedData)")
                    let sectionItems: [DetailInfoSectionItem] = mappedData.flatMap { model in
                        [
                            .Tag([model.id]),
                            .Thumbnail([UIImage.Sample.sample1 ?? UIImage()]),
                            .Third([Double(model.audienceCount)])
                        ]
                    }
                    observer.onNext(sectionItems) // 변환된 데이터 방출
                    observer.onCompleted()
                } catch {
                    print("Error fetching data: \(error)")
                    // 예외 발생 시 에러를 PublishRelay에 전달하고, dummyData를 사용
                    self.error.accept(error)
                    observer.onNext(self.dummyData) // 더미 데이터를 반환
                    observer.onCompleted()
                }
            }

            return Disposables.create()
        }
    }
}
