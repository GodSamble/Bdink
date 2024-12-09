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
    private let repository: RepositoryInterface_test
    private let sectionsRelay = BehaviorRelay<[DetailInfoSectionItem]>(value: [])
    private let disposeBag = DisposeBag()
    private var tagButtons: [UIButton] = []
    
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
    
    private var dummyData: [DetailInfoSectionItem] = []
    
    func transform(input: Input) -> Output {
        let dataSource = input.viewDidLoad
            .flatMapLatest { [weak self] _ -> Observable<[DetailInfoSectionItem]> in
                guard let self = self else { return .just([]) }
                return self.repository.fetchData(lat: 37.7749, lon: -122.4194)
                    .map { welcome -> [DetailInfoSectionItem] in
                        var result = [DetailInfoSectionItem]()
                        // Case 1: Tag - weather의 main 값을 추출하여 [String] 생성
                        let tags = welcome.weather.map { $0.main }
                        result.append(.Tag(tags))
                        
                        // Case 2: Thumbnail - weather의 icon 값을 UIImage로 변환
                        let thumbnails = welcome.weather.compactMap { UIImage(named: $0.icon) }
                        result.append(.Thumbnail(thumbnails))
                        
                        // Case 3: Third - main의 온도 값(temp, tempMin, tempMax) 추출하여 [Double] 생성
                        let thirdValues = [welcome.main.temp, welcome.main.tempMin, welcome.main.tempMax]
                        result.append(.Third(thirdValues))
                        return result
                    }
                    .catchAndReturn([])
            }
        
        return Output(dataSource: dataSource)
    }
}



