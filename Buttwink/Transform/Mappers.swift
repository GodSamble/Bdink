//
//  Mappers.swift
//  Buttwink
//
//  Created by 고영민 on 1/5/25.
//

import Foundation

struct WeatherPresentationModel {
    let cityName: String
    let temperature: String
    let humidity: String
    let weatherDescription: String
}


protocol MypageDataMapper {
    func transform(_ dto: Welcome) -> [WeatherPresentationModel]
}

//final class DefaultMypageDataMapper: MypageDataMapper {
//    func transform(_ dto: Welcome) -> [MypagePresentationModel] {
//        return dto.name.map { name in
//            MypagePresentationModel(id: name.description, title: name.description, audienceCount: name.description, releaseDate: name.description
//            )
//        }
//    }
//}


