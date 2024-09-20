//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Shubham Gupta on 19/09/24.
//

import Foundation

class SearchViewModel {
    // Completion handler to send results to the ViewController
    var onCitiesFetched: (([City]) -> Void)?
    var onError: ((String) -> Void)?
    
    let weatherService: WeatherService
    
    init(weatherService: WeatherService = WeatherService()) {
        self.weatherService = weatherService
    }
    
    // Fetch cities based on query
    func searchCities(query: String) {
        weatherService.searchCities(query: query) { [weak self] result in
            switch result {
            case .success(let cities):
                DispatchQueue.main.async {
                    self?.onCitiesFetched?(cities)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.onError?("Failed to fetch cities: \(error.localizedDescription)")
                }
            }
        }
    }
}
