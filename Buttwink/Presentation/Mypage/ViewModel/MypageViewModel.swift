//
//  MypageViewModel.swift
//  Buttwink
//
//  Created by 고영민 on 11/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MypageViewModel: CommonViewModelType {
    // Clean Arc 
//    init() {
//        loadInitialData()
//    }
    
    private let sectionsRelay = BehaviorRelay<[SectionLayoutKind: [DetailInfoSectionItem]]>(value: [:])
    
    private let disposeBag = DisposeBag()
    
    // MARK: Input
    struct Input { //입력 받는거
        let viewDidLoad: Observable<Void>
    }
    //MARK: PublishSubject
    
    // MARK: Output
    struct Output {
        let dataSource: Observable<[DetailInfoSectionItem]>
    }

    func transform(input: Input) -> Output {
        
        let data = input.viewDidLoad
            .map { _ in
                // loadInitialData()에서 준비한 데이터를 사용
                self.sectionsRelay.value
            }
            .do(onNext: { sections in
                // 필요하면 데이터를 처리
                print("Loaded initial data: \(sections)")
            })
        
        let dataSource = data.map { dto -> [DetailInfoSectionItem] in
            var result = [DetailInfoSectionItem]()
            
            // 섹션을 순회하면서 DetailInfoSectionItem을 생성
            SectionLayoutKind.allCases.forEach { section in
                switch section {
                case .ThumbnailView:
                    result.append(.thumbnail("Default Thumbnail"))
                case .TagView:
                    result.append(.tag("Default Tag"))
                case .ThirdView:
                    result.append(.third(3.0))
                }
            }
            return result
        }
        
        return Output(dataSource: dataSource)
    }
}
    


