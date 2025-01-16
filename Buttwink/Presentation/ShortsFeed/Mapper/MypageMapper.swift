//
//  MypageMapper.swift
//  Buttwink
//
//  Created by 고영민 on 1/5/25.
//

import Foundation

struct MypagePresentationModel {
    let id: Int
    let title: Int
    let audienceCount: Int
    let releaseDate: Int
}

protocol MypageMapper {
    func transform(_ entity: [Welcome]) -> [MypagePresentationModel] // Entity -> Model
}

final class DefaultMypagePresentationMapper: MypageMapper {
    
    func transform(_ entity: [Welcome]) -> [MypagePresentationModel] {
        return entity.map { s in
            MypagePresentationModel(
                id: s.main.pressure,
                title: s.main.pressure,
                audienceCount: s.main.pressure,
                releaseDate: s.main.pressure
            )
        }
    }
}
