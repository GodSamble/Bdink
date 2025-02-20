//
//  RepositoryInterface_Youtube.swift
//  Buttwink
//
//  Created by 고영민 on 1/23/25.
//

import Foundation

protocol RepositoryInterface_Youtube {
    func fetchYoutubeSearch(query: String, maxResults: Int) async throws -> (
        search: Entity_YoutubeData,
        video: Entity_YoutubeVideoData,
        channel: Entity_YoutubeChannelData
    )
}
