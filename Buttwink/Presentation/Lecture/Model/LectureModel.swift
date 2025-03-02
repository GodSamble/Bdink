//
//  LectureModel.swift
//  Buttwink
//
//  Created by 고영민 on 2/22/25.
//

import Foundation
import UIKit

// MARK: - Section Data

enum SectionItem_Lecture: Hashable, Equatable {
    
    case Head([Head])
    case Purchase([Purchase])
    case Review([Review])
    case CurriCulum([Curriculum])
    
    var headerTitle: String {
           switch self {
           case .Head:
               return "클래스 추천"
           case .Purchase:
               return "구매 클래스"
           case .Review:
               return "수강 후기"
           case .CurriCulum:
               return "강의 커리큘럼"
           }
       }
    
    public func getSectionLayoutKind() -> SectionLayoutKind_Lecture {
        switch self {
        case .Head: return .head
        case .Purchase: return .purchase
        case .Review: return .review
        case .CurriCulum: return .curriculum
        }
    }
}
// MARK: - Item

enum SectionLayoutKind_Lecture: Int, CaseIterable, Hashable {
    case head, purchase, review, curriculum
}

struct HeaderStruct: Hashable {
    let title: String
}

struct Head: Hashable {
    let thumbnail: UIImage
    let title: String
    let bookmarkNum: Int
    let kindOfLecture: String
    let chapterNum: Int
    let runningTime: String
}

struct Purchase: Hashable {
    let normalPrice: Int
    let discountPrice: Int
    let discoutPercent: Int
}

struct Review: Hashable {
    let reviewContent: String
    let nickName: String
}

struct Curriculum: Hashable {
    let learningDate: Date
    let lectureNum: Int
    let leaningTime: Int
    let detailChapter: String
    let detailContent: String
    let detailLearningTime : String
}


