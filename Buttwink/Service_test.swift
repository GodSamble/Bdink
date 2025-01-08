//
//  TestService.swift
//  Buttwink
//
//  Created by 고영민 on 12/4/24.
//

import Foundation
import Moya
import RxSwift

protocol TestServiceProtocol {
    func fetchGetMethod(lat: Double, lon: Double) async throws -> BaseResponse<[Welcome]>
}

final class TestService {
    private let provider: MoyaProvider<TestAPI>
    
    init(provider: MoyaProvider<TestAPI> = .init()) {
        self.provider = provider
    }
    
    func getTotalTest(lat: Double, lon: Double) -> Observable<BaseResponse<Welcome>> {
        return Observable.create { observer in
            self.provider.request(.getWeatherTest(lat: lat, lon: lon)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try response.map(BaseResponse<Welcome>.self)
                        observer.onNext(decodedResponse)
                        observer.onCompleted()
                    } catch let error {
                        observer.onError(error)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
