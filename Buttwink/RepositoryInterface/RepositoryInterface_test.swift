//
//  RepositoryInterface_test.swift
//  Buttwink
//
//  Created by 고영민 on 12/10/24.
//

import Foundation
import RxSwift

protocol RepositoryInterface_test {
    func fetchGetMethod(lat: Double, lon: Double) async throws -> [Welcome]
}


//MARK: 목데이터
final class MockRepository: RepositoryInterface_test {
    var shouldReturnError = false

    func fetchGetMethod(lat: Double, lon: Double) async throws -> [Welcome] {
        if shouldReturnError {
            throw NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error occurred"])
        }
        return [Welcome(
            coord: Coord(lon: 135.0, lat: 34.7),
            weather: [
                Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")
            ],
            base: "stations",
            main: Main(
                temp: 298.15,
                feelsLike: 300.15,
                tempMin: 297.15,
                tempMax: 299.15,
                pressure: 1013,
                humidity: 50,
                seaLevel: 1013,
                grndLevel: 1012
            ),
            visibility: 10000,
            wind: Wind(speed: 3.5, deg: 220, gust: 5.0),
            rain: Rain(the1H: 0.0),
            clouds: Clouds(all: 0),
            dt: 1698739200,
            sys: Sys(
                type: 1,
                id: 8074,
                country: "JP",
                sunrise: 1698728400,
                sunset: 1698769200
            ),
            timezone: 32400,
            id: 1853909,
            name: "Osaka",
            cod: 200
        )
    ]
    }
}
