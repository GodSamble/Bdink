//
//  RepositoryInterface_test.swift
//  Buttwink
//
//  Created by 고영민 on 12/10/24.
//

import Foundation
import RxSwift

protocol RepositoryInterface_test {
    // RxSwift Observable 방식으로 데이터를 가져옴.
    func data() -> Observable<Welcome>
    
    // Swift Concurrency 방식으로 데이터를 가져옴.
    func dataAsync() async throws -> Welcome
}
