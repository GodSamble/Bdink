//
//  Entity_test.swift
//  Buttwink
//
//  Created by 고영민 on 12/10/24.
//

import Foundation


struct Video: Codable, Equatable {
    let index: Int
    let thumbnailURL: String
    let title: String
}

let dummyVideos: [Video] = (1...100).map {
    Video(index: $0, thumbnailURL: "https://placekitten.com/200/200?image=\($0)", title: "Video \($0)")
}


struct Welcome: Codable, Equatable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let rain: Rain
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}


// MARK: - Clouds
struct Clouds: Codable, Equatable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable, Equatable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable, Equatable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Rain
struct Rain: Codable, Equatable {
    let the1H: Double
    
    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - Sys
struct Sys: Codable, Equatable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable, Equatable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind
struct Wind: Codable, Equatable {
    let speed: Double
    let deg: Int
    let gust: Double
}

