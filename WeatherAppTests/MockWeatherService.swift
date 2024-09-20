//
//  MockWeatherService.swift
//  WeatherAppTests
//
//  Created by Shubham Gupta on 20/09/24.
//

import Foundation
import XCTest
@testable import WeatherApp

class MockWeatherService: WeatherService {
    
    var shouldReturnError = false
    var mockCities: [City] = []
    var weatherResponse: WeatherResponse?
    var forecastResponse: ForecastResponse?
    
    override func searchCities(query: String, completion: @escaping (Result<[City], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Mock Error"])))
        } else {
            completion(.success(mockCities))
        }
    }
    
    override func fetchWeatherData(lat: Double, lon: Double, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Mock Error"])))
        } else if let response = weatherResponse {
            completion(.success(response))
        }
    }
    
    override func fetchWeatherForecast(lat: Double, lon: Double, completion: @escaping (Result<ForecastResponse, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Mock Error"])))
        } else if let response = forecastResponse {
            completion(.success(response))
        }
    }
}
