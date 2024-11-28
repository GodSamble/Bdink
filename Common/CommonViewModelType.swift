//
//  CommonViewModelType.swift
//  Buttwink
//
//  Created by 고영민 on 11/26/24.
//

import Foundation
import RxSwift

protocol CommonViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
