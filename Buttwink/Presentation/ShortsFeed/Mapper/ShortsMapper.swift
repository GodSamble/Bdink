//
//  ShortsMapper.swift
//  Buttwink
//
//  Created by 고영민 on 1/23/25.
//

import UIKit

protocol DetailInfoSectionMapper {
    func transform(searchModels models: [Entity_YoutubeData], channelModels: [Entity_YoutubeChannelData], videoModels: [Entity_YoutubeVideoData]) -> [DetailInfoSectionItem]
}

final class DetailInfoSectionMapperImpl: DetailInfoSectionMapper {
    
    func transform(
        searchModels models: [Entity_YoutubeData],
        channelModels: [Entity_YoutubeChannelData],
        videoModels: [Entity_YoutubeVideoData]
    ) -> [DetailInfoSectionItem] {
        
        let tags = models.map { $0.channelId }
        
        // ✅ 채널 데이터 매핑 (channelId -> 채널 썸네일)
        let channelDict = Dictionary(uniqueKeysWithValues: channelModels.map { ($0.channelThumbnailUrl, $0) })
        
        // ✅ 비디오 데이터 매핑 (조회수 정보)
        let videoDict = Dictionary(uniqueKeysWithValues: videoModels.map { ($0.viewCount, $0) })
        
        // ✅ Unified 타입으로 변환
        let unifiedItems: [UnifiedYoutubeEntity] = models.map { model in
            let channelThumbnail = channelDict[model.channelId]?.channelThumbnailUrl ?? ""
            print("Channel not found for channelId: \(model.channelId)")
            let viewCount = videoDict[model.videoId ?? ""]?.viewCount ?? "0"

            return UnifiedYoutubeEntity(
                viewCount: viewCount,
                channelThumbnailUrl: channelThumbnail,
                title: model.title,
                thumbnailUrl: model.thumbnailUrl,
                channelId: model.channelId,
                channelName: model.channelName
            )
        }
        
        let placeholderImages = [UIImage(named: "placeholder") ?? UIImage()]
        
        return [
            .Tag(tags), // 태그를 포함
            .Thumbnail(unifiedItems), // ✅ 통합된 데이터 모델을 Thumbnail로 전달
            .Third(placeholderImages) // 추가 섹션
        ]
    }
}
