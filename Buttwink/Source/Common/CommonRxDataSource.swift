//
//  CommonRxDataSource.swift
//  Buttwink
//
//  Created by 고영민 on 2/10/25.
//

import Foundation
import RxDataSources

typealias CommonSectionModel<T> = SectionModel<Int, T>

typealias HeaderSectionModel<T> = SectionModel<String, T>

typealias GenericSectionModel<T, U> = SectionModel<T, U>

struct CommonHeaderSectionModel<T> {
    var header: String
    var items: [T]
}
extension CommonHeaderSectionModel: SectionModelType {
    typealias Item = T
    
    init(original: CommonHeaderSectionModel<T>, items: [T]) {
        self = original
        self.items = items
    }
}
