//
//  CustomMoyaProvider.swift
//  Buttwink
//
//  Created by 고영민 on 12/4/24.
//

import Foundation

import Moya

class CustomMoyaProvider<Target: TargetType>: MoyaProvider<Target> {
    convenience init() {
        let plugins: [PluginType] = [MoyaLoggerPlugin()]
        // let session = Session(interceptor: SessionInterceptor())
        self.init(plugins: plugins)
    }
}
