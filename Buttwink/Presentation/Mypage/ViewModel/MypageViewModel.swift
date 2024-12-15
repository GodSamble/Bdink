//
//  MypageViewModel.swift
//  Buttwink
//
//  Created by 고영민 on 11/26/24.
//

import UIKit
import RxSwift
import DesignSystem
import RxCocoa
import RxDataSources

final class MypageViewModel: CommonViewModelType {
    let datasourceRelay = BehaviorRelay<[DetailInfoSectionItem]>(value: [])
    
    private let repository: RepositoryInterface_test
    private let disposeBag = DisposeBag()
    
    init(repository: RepositoryInterface_test) {
        self.repository = repository
    }
    
    // MARK: Input
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    // MARK: Output
    struct Output {
        let dataSource: Observable<[DetailInfoSectionItem]>
    }
    
     var dummyData: [DetailInfoSectionItem] = [
        .Tag(["Sunny", "Rainy", "Cloudy"]),
        .Thumbnail([
            UIImage.Sample.sample1 ?? UIImage(), // Use a default image if "sample" is not found
            UIImage.Sample.sample1 ?? UIImage()  // Same here for the second image
        ]),
        .Third([30.0, 22.0, 35.0])
    ]
    
    
    func transform(input: Input) -> Output {
            input.viewDidLoad
                .flatMapLatest { [weak self] _ -> Observable<[DetailInfoSectionItem]> in
                    guard let self = self else { return .just([]) }

                    // Check if datasourceRelay already has data
                    if !self.datasourceRelay.value.isEmpty {
                        return .just(self.datasourceRelay.value) // Return cached data
                    }

                    return self.repository.data()
                        .do(onNext: { data in
                            print("Received data: \(data)") // 데이터 확인
                        })
                        .map { welcome -> [DetailInfoSectionItem] in
                            print("Parsed welcome data: \(welcome)")  // welcome 데이터 확인
                            let result = [DetailInfoSectionItem]()
                            // 데이터 변환 작업을 여기에 추가
                            return result
                        }
                        .catchAndReturn(self.dummyData) // 실패 시 dummyData 반환
                        .do(onNext: { result in
                            
                            self.datasourceRelay.accept(result) // Cache the result
                        })
                }
                .bind(to: datasourceRelay)
                .disposed(by: disposeBag)

            return Output(dataSource: datasourceRelay.asObservable())
        }
    }
