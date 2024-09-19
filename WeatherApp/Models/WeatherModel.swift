//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Shubham Gupta on 19/09/24.
//

import Foundation

struct WeatherResponse: Decodable {
    let coord: Coordinates
    let weather: [Weather]
    let main: MainWeather
    let name: String
    let wind: Wind
}

struct Coordinates: Decodable {
    let lat: Double
    let lon: Double
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct MainWeather: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Wind: Decodable {
    let speed: Double
    let deg: Double
}
