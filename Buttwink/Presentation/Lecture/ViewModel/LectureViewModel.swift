//
//  LectureViewModel.swift
//  Buttwink
//
//  Created by 고영민 on 2/22/25.
//

import UIKit
import RxSwift
import RxCocoa

final class LectureViewModel {
    
    // 데이터 스트림을 위한 Subject
    private let lectureContentsSubject = BehaviorSubject<[SectionItem_Lecture]>(value: [])
    var lectureContents: Observable<[SectionItem_Lecture]> {
        return lectureContentsSubject.asObservable()
    }
    
    private let disposeBag = DisposeBag()
    
    init() {
        setupDummyData()
    }
    
    private func setupDummyData() {
        let sampleData: [SectionItem_Lecture] = [
            .Head([
                Head(
                    thumbnail: UIImage(),
                    title: "iOS 앱 개발 마스터 코스",
                    bookmarkNum: 250,
                    kindOfLecture: "10시 10분",
                    chapterNum: 15,
                    runningTime: "5시간 30분"
                )
            ]),
            .Purchase([
                Purchase(
                    normalPrice: 200000,
                    discountPrice: 149000,
                    discoutPercent: 25
                )
            ]),
            .Review([
                Review(
                    reviewContent: "강의가 정말 이해하기 쉬웠어요! 추천합니다.",
                    nickName: "코딩초보"
                ),
                Review(
                    reviewContent: "예제 코드가 많아서 따라하기 좋네요.",
                    nickName: "SwiftMaster"
                )
            ]),
            .CurriCulum([
                Curriculum(
                    learningDate: Date(),
                    lectureNum: 1,
                    leaningTime: 45,
                    detailChapter: "Swift 기본 문법",
                    detailContent: "변수, 상수, 연산자, 제어문 학습",
                    detailLearningTime: "45분"
                ),
                Curriculum(
                    learningDate: Date(),
                    lectureNum: 2,
                    leaningTime: 60,
                    detailChapter: "UIKit을 활용한 UI 개발",
                    detailContent: "Storyboard와 코드로 UI 구성하기",
                    detailLearningTime: "1시간"
                )
            ])
        ]
        
        lectureContentsSubject.onNext(sampleData)
    }
}
