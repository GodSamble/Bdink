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
    private let sectionsRelay = BehaviorRelay<[SectionLayoutKind: [DetailInfoSectionItem]]>(value: [:])
    private let disposeBag = DisposeBag()
    private var tagButtons: [UIButton] = []

    // MARK: Input
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    // MARK: Output
    struct Output {
        let dataSource: Observable<[DetailInfoSectionItem]>
    }
    
    private var dummyData: [DetailInfoSectionItem] = []
    
    init() {
        // 더미 데이터를 한번만 초기화
        dummyData = [
            .Tag(["Dummy Tag 1", "Dummy Tag 2", "Dummy Tag 2"]),
            .Thumbnail([UIImage(named: "Sample"), UIImage(named: "Sample2")].compactMap { $0 }),
            .Third([1.0, 2.0, 3.0])
        ]
    }
    
    func transform(input: Input) -> Output {
        let dataSource = input.viewDidLoad
            .map { [weak self] _ -> [DetailInfoSectionItem] in
                return self?.dummyData ?? []
            }
        
        return Output(dataSource: dataSource)
    }
}



