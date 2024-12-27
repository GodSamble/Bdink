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
    
    // MARK: 임시 더미데이터
    var dummyData: [DetailInfoSectionItem] = [
        .Tag(["Sunny", "Rainy", "Cloudy"]),
        .Thumbnail([
            UIImage.Sample.sample1 ?? UIImage(),
            UIImage.Sample.sample1 ?? UIImage()
        ]),
        .Third([30.0, 22.0, 35.0])
    ]
    
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .flatMapLatest { [weak self] _ -> Observable<[DetailInfoSectionItem]> in
                guard let self = self else { return .just([]) }
                
                if !self.datasourceRelay.value.isEmpty {
                    return .just(self.datasourceRelay.value)
                }
                
                return self.fetchData()
                    .catch { _ in
                            .just(self.dummyData)
                    }
                    .do(onNext: { self.datasourceRelay.accept($0) })
            }
            .bind(to: datasourceRelay)
            .disposed(by: disposeBag)
        
        return Output(dataSource: datasourceRelay.asObservable())
    }
    
    private func fetchData() -> Observable<[DetailInfoSectionItem]> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            Task {
                do {
                    let welcomeData = try await self.repository.dataAsync()
                    let transformedData = self.transformData(welcomeData)
                    observer.onNext(transformedData)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    private func transformData(_ welcome: Welcome) -> [DetailInfoSectionItem] {
        var items: [DetailInfoSectionItem] = []
        
        let tags = welcome.weather.map { $0.description }
        items.append(.Tag(tags))
        
        let thumbnails = [
            UIImage.Sample.sample1 ?? UIImage(),
            UIImage.Sample.sample1 ?? UIImage()
        ]
        items.append(.Thumbnail(thumbnails))
        
        let thirdData = [Double(welcome.main.temp), Double(welcome.main.humidity)]
        items.append(.Third(thirdData))
        
        return items
    }
}
