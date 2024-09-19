//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Shubham Gupta on 19/09/24.
//

import Foundation

class SearchViewModel {
    
    let apiKey = "429f49c804ceb7433e9f3c5fe4075c91"
    
    // Completion handler to send results to the ViewController
    var onCitiesFetched: (([City]) -> Void)?
    var onError: ((String) -> Void)?
    
    // Fetch cities based on query
    func searchCities(query: String) {
        let limit = 5
        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(query)&limit=\(limit)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            onError?("Invalid URL")
            return
        }
        
        // Fetch data from the API
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                self?.onError?("Failed to fetch data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                // Decode JSON response
                let cities = try JSONDecoder().decode([City].self, from: data)
                DispatchQueue.main.async {
                    self?.onCitiesFetched?(cities)
                }
            } catch {
                DispatchQueue.main.async {
                    self?.onError?("Failed to decode data: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
