//
//  TestService.swift
//  Buttwink
//
//  Created by 고영민 on 12/4/24.
//

import Foundation
import Moya

final class TestService {

    let testProvider = CustomMoyaProvider<TestAPI>()
    private(set) var testData: BaseResponse<Welcome>?

    func getTotalTest(lat: Double, lon: Double, completion: @escaping (BaseResponse<Welcome>?) -> Void) {
        testProvider.request(.getWeatherTest(lat: lat, lon: lon)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    // Parsing the response into the model
                    self?.testData = try response.map(BaseResponse<Welcome>.self)
                    completion(self?.testData)
                } catch let error {
                    print("Parsing error: \(error.localizedDescription)")
                    completion(nil)
                }
            case .failure(let error):
                print("Request failed: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
