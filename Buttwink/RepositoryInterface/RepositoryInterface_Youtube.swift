//
//  RepositoryInterface_Youtube.swift
//  Buttwink
//
//  Created by 고영민 on 1/23/25.
//

import Foundation

protocol RepositoryInterface_Youtube {
    func fetchYoutubeVideoList(id: String, part: String) async throws -> [Entity_YoutubeData]
}
