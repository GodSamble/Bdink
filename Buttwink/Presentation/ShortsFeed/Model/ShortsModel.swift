//
//  ShortsModel.swift
//  Buttwink
//
//  Created by 고영민 on 1/23/25.
//

import Foundation
import UIKit

// MARK: - Section Data

enum DetailInfoSectionItem: Hashable, Equatable {
    
    case Tag([String])
    case Thumbnail([VideoItem])
    case Third([UIImage])
    
    public func getSectionLayoutKind() -> SectionLayoutKind {
        switch self {
        case .Tag: return .tags
        case .Thumbnail: return .videoItem
        case .Third: return .thirdSection
        }
    }
}
// MARK: - Item

enum SectionLayoutKind: Int, CaseIterable, Hashable {
    case tags, videoItem, thirdSection
}
