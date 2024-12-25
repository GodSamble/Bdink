//
//  MJViewModel.swift
//  Buttwink
//
//  Created by 이명진 on 12/23/24.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output
}

final class MJViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let movieData: Observable<[BoxOffice]>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let input = input.viewDidLoad
            .map { _ in }
    }

}
