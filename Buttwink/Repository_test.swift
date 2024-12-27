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
    func dataAsync() async throws -> Welcome {
          return try await withCheckedThrowingContinuation { continuation in
              data()
                  .subscribe { event in
                      switch event {
                      case .next(let data):
                          continuation.resume(returning: data)
                      case .error(let error):
                          continuation.resume(throwing: error)
                      case .completed:
                          break
                      }
                  }
                  .disposed(by: DisposeBag())
          }
      }
    
    
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
                guard let data = response.data else {
                    return Observable<Welcome>.error(NSError(domain: "RepositoryError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data is nil"]))
                }
                return Observable.just(data)
            }
            .catch { error in
                return Observable<Welcome>.error(error)
            }
    }
}
