//
//  SearchViewModelTests.swift
//  WeatherAppTests
//
//  Created by Shubham Gupta on 20/09/24.
//

import Foundation
import XCTest
@testable import WeatherApp

class SearchViewModelTests: XCTestCase {

    var viewModel: SearchViewModel!
    var mockService: MockWeatherService!

    override func setUp() {
        super.setUp()
        mockService = MockWeatherService()
        viewModel = SearchViewModel(weatherService: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    // Test success scenario
    func testSearchCitiesSuccess() {
        // Given
        let mockCities = [
            City(name: "City1", country: "", state: "", lat: 12.34, lon: 56.78),
            City(name: "City2", country: "", state: "", lat: 23.45, lon: 67.89)
        ]
        mockService.mockCities = mockCities
        
        let expectation = self.expectation(description: "Cities fetched")
        
        // When
        viewModel.onCitiesFetched = { cities in
            XCTAssertEqual(cities.count, 2)
            XCTAssertEqual(cities[0].name, "City1")
            XCTAssertEqual(cities[1].name, "City2")
            expectation.fulfill()
        }
        
        viewModel.searchCities(query: "TestCity")
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    // Test failure scenario
    func testSearchCitiesFailure() {
        // Given
        mockService.shouldReturnError = true
        
        let expectation = self.expectation(description: "Error triggered")
        
        // When
        viewModel.onError = { error in
            XCTAssertEqual(error, "Failed to fetch cities: Mock Error")
            expectation.fulfill()
        }
        
        viewModel.searchCities(query: "TestCity")
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
    }
}

