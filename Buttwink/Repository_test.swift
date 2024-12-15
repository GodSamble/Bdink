//
//  Repository_test.swift
//  Buttwink
//
//  Created by 고영민 on 12/10/24.
//

import Foundation
import RxSwift
import Moya


final class Repository_test: RepositoryInterface_test {
    
    private let service: TestService
    private let lat: Double
    private let lon: Double
    
    init(service: TestService, lat: Double, lon: Double) {
        self.service = service
        self.lat = lat
        self.lon = lon
    }
    
    func data() -> Observable<Welcome> {
        return service.getTotalTest(lat: lat, lon: lon)
            .flatMap { response in
                // data가 nil일 경우 에러 발생
                guard let data = response.data else {
                    return Observable<Welcome>.error(NSError(domain: "RepositoryError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data is nil"]))
                }
                return Observable.just(data) // data가 존재하면 Observable<Welcome> 반환
            }
            .catch { error in
                // 에러 처리, Observable<Welcome>을 반환해야 함
                return Observable<Welcome>.error(error) // Observable<Welcome>을 반환
            }
    }
}
