//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Shubham Gupta on 20/09/24.
//

import Foundation
import XCTest
@testable import WeatherApp

class WeatherViewModelTests: XCTestCase {
    
    var viewModel: WeatherViewModel!
    var mockService: MockWeatherService!
    
    override func setUp() {
        super.setUp()
        mockService = MockWeatherService()
        viewModel = WeatherViewModel(weatherService: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchWeatherDataSuccess() {
        // Given
        let mockCity = City(name: "TestCity", country: "", state: "", lat: 12.34, lon: 56.78)
        let mockWeatherResponse = WeatherResponse(coord: Coordinates(lat: 12.34, lon: 56.78), weather: [], main: MainWeather(temp: 20.0, feels_like: 19.0, temp_min: 18.0, temp_max: 22.0, pressure: 1012, humidity: 65), name: "", wind: Wind(speed: 0, deg: 0))
        mockService.weatherResponse = mockWeatherResponse
        
        let expectation = self.expectation(description: "Weather data fetched")
        
        // When
        viewModel.onWeatherDataFetched = {
            expectation.fulfill()
        }
        
        viewModel.fetchWeatherData(city: mockCity)
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertNotNil(viewModel.weatherResponse)
        XCTAssertEqual(viewModel.weatherResponse?.main.temp, 20.0)
    }
    
    func testFetchWeatherDataFailure() {
        // Given
        let mockCity = City(name: "TestCity", country: "", state: "", lat: 12.34, lon: 56.78)
        mockService.shouldReturnError = true
        
        let expectation = self.expectation(description: "Error triggered")
        
        // When
        viewModel.onError = { error in
            XCTAssertEqual(error, "Error fetching weather data: Mock Error")
            expectation.fulfill()
        }
        
        viewModel.fetchWeatherData(city: mockCity)
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertNil(viewModel.weatherResponse)
    }
    
    func testFetchDailyWeatherSuccess() {
        // Given
        let mockCity = City(name: "TestCity", country: "", state: "", lat: 12.34, lon: 56.78)
        
        let mockForecast = Forecast(dt: 1625594400, main: MainWeather(temp: 20.0, feels_like: 19.0, temp_min: 18.0, temp_max: 22.0, pressure: 1012, humidity: 65), weather: [Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")], dt_txt: "2023-09-20 12:00:00")
        
        let mockForecastResponse = ForecastResponse(list: [mockForecast], city: CityInfo(name: "TestCity", country: "US"))
        mockService.forecastResponse = mockForecastResponse
        
        let expectation = self.expectation(description: "Daily weather data fetched")
        
        // When
        viewModel.onDailyWeatherFetched = {
            expectation.fulfill()
        }
        
        viewModel.fetchDailyWeather(city: mockCity)
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertEqual(viewModel.dailyWeather.count, 1)
        XCTAssertEqual(viewModel.dailyWeather.first?.date, "2023-09-20")
    }
    
    func testFetchDailyWeatherFailure() {
        // Given
        let mockCity = City(name: "TestCity", country: "", state: "", lat: 12.34, lon: 56.78)
        mockService.shouldReturnError = true
        
        let expectation = self.expectation(description: "Error triggered")
        
        // When
        viewModel.onError = { error in
            XCTAssertEqual(error, "Error fetching weather data: Mock Error")
            expectation.fulfill()
        }
        
        viewModel.fetchDailyWeather(city: mockCity)
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertEqual(viewModel.dailyWeather.count, 0)
    }
}
