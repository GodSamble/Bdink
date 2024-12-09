//
//  Repository_test.swift
//  Buttwink
//
//  Created by 고영민 on 12/10/24.
//

import Foundation
import RxSwift

protocol RepositoryInterface_test {
    func fetchData(lat: Double, lon: Double) -> Observable<Welcome>
}

final class Repository_test: RepositoryInterface_test {
    private let service: TestService
    
    init(service: TestService) {
        self.service = service
    }
    
    func fetchData(lat: Double, lon: Double) -> Observable<Welcome> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(NSError(domain: "RepositoryError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"]))
                return Disposables.create()
            }
            
            self.service.getTotalTest(lat: lat, lon: lon) { response in
                if let data = response?.data {
                    observer.onNext(data)
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: "RepositoryError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch weather data"]))
                }
            }
            return Disposables.create()
        }
    }
}

