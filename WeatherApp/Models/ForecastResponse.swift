//
//  ForecastResponse.swift
//  WeatherApp
//
//  Created by Shubham Gupta on 19/09/24.
//

import Foundation

struct ForecastResponse: Decodable {
    let list: [Forecast]
    let city: CityInfo
}

struct Forecast: Decodable {
    let dt: Int // UNIX timestamp
    let main: MainWeather
    let weather: [Weather]
    let dt_txt: String // Date in string format for readability
}

struct CityInfo: Decodable {
    let name: String
    let country: String
}

struct DailyWeather {
    let date: String
    let tempMin: Double
    let tempMax: Double
    let description: String
}

