//
//  CategoryVideosViewModel.swift
//  Buttwink
//
//  Created by 고영민 on 1/13/25.
//

import UIKit
import RxSwift
import RxCocoa

protocol CategoryViewModelInput {
    var viewDidLoad: PublishRelay<Void> { get }
}

protocol CategoryViewModelOutput {
    var dataSource: BehaviorRelay<[DetailInfoSectionItem2]> { get }
    var error: PublishRelay<Error> { get }
}

protocol CategoryViewModelType {
    var inputs: CategoryViewModelInput { get }
    var outputs: CategoryViewModelOutput { get }
}

final class CategoryVideosViewModel: CategoryViewModelInput, CategoryViewModelOutput, CategoryViewModelType {
    var viewDidLoad: PublishRelay<Void> = PublishRelay()
    var dataSource: BehaviorRelay<[DetailInfoSectionItem2]> = BehaviorRelay(value: [])
    var error: PublishRelay<Error> = PublishRelay()
    
    var inputs: CategoryViewModelInput { return self }
    var outputs: CategoryViewModelOutput { return self }
    
    private let disposeBag = DisposeBag()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        viewDidLoad
            .flatMapLatest { [weak self] _ -> Observable<[DetailInfoSectionItem2]> in
                guard let self = self else { return Observable.just([]) }
                return self.fetchData()
                    .catch { [weak self] error in
                        self?.error.accept(error)
                        return .just([])
                    }
            }
            .bind(to: dataSource)
            .disposed(by: disposeBag)
    }
    
    private func fetchData() -> Observable<[DetailInfoSectionItem2]> {
        // Placeholder for fetching data
        return Observable.just([.CategoryVideo([1, 2, 3, 4, 5])])
    }
    

}
