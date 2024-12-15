//
//  GetServiceRx.swift
//  Buttwink
//
//  Created by 고영민 on 12/14/24.
//

import Foundation
import RxSwift
import Alamofire
import Sentry

final class GetServiceRx {
    static let shared = GetServiceRx()
    private let session: Session
    
    private let tokenUtils = HeaderUtils()
    
    init(session: Session = Session.default) {
        self.session = session
    }
    
    func getService<T: Decodable>(from url: String, isUseHeader: Bool) -> Single<T> {
        return Single<T>.create { single in
            let request = self.session.request(
                url,
                method: .get,
                encoding: JSONEncoding.default,
                headers: isUseHeader ? self.tokenUtils.getAuthorizationHeader() : self.tokenUtils.getNormalHeader()
            ).response { response in
                do {
                    guard let resData = response.data else {
                        single(.failure(ErrorType.parsingError))
                        return
                    }
                    let data = try JSONDecoder().decode(T.self, from: resData)
                    single(.success(data))
                } catch {
                    do {
                        guard let resData = response.data else {
                            single(.failure(ErrorType.unknown))
                            return
                        }
                        let errorCode = try JSONDecoder().decode(ErrorCode.self, from: resData)
                        single(.failure(ErrorType(rawValue: errorCode.code) ?? .unknown))
                    } catch {
                        SentrySDK.capture(error: error)
                        single(.failure(error))
                    }
                }
            }
            
            // DisposeBag 관리
            return Disposables.create {
                request.cancel()
            }
        }
    }
}


