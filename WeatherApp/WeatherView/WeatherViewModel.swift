//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Shubham Gupta on 19/09/24.
//

import Foundation

class WeatherViewModel {
    var city: City?

    var weatherResponse: WeatherResponse? {
        didSet {
            // When data is set, notify the ViewController
            self.onWeatherDataFetched?()
        }
    }
    
    var onWeatherDataFetched: (() -> Void)?
    var onError: ((String) -> Void)?
    
    var dailyWeather: [DailyWeather] = [] {
            didSet {
                self.onDailyWeatherFetched?()
            }
        }
        
    var onDailyWeatherFetched: (() -> Void)?
    
    private let weatherService: WeatherService
    
    init(weatherService: WeatherService = WeatherService()) {
        self.weatherService = weatherService
    }
    
    func fetchWeatherData(city: City) {
        weatherService.fetchWeatherData(lat: city.lat, lon: city.lon) { [weak self] result in
            switch result {
            case .success(let weatherResponse):
                // Process the data to get daily weather
                DispatchQueue.main.async {
                    self?.weatherResponse = weatherResponse
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.onError?("Error fetching weather data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchDailyWeather(city: City) {
        weatherService.fetchWeatherForecast(lat: city.lat, lon: city.lon) { [weak self] result in
            switch result {
            case .success(let forecastResponse):
                // Process the data to get daily weather
                let dailyWeather = self?.processDailyWeather(forecastResponse)
                DispatchQueue.main.async {
                    self?.dailyWeather = dailyWeather ?? []
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.onError?("Error fetching weather data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func processDailyWeather(_ forecastResponse: ForecastResponse) -> [DailyWeather] {
        // Group forecasts by date
        let groupedForecasts = Dictionary(grouping: forecastResponse.list) { (forecast) -> String in
            let date = forecast.dt_txt.split(separator: " ")[0]
            return String(date)
        }
        
        // Create DailyWeather summaries
        var dailyWeatherList: [DailyWeather] = []
        
        for (date, forecasts) in groupedForecasts {
            // Get the min and max temp for each day
            let tempMin = forecasts.map { $0.main.temp_min }.min() ?? 0.0
            let tempMax = forecasts.map { $0.main.temp_max }.max() ?? 0.0
            let description = forecasts.first?.weather.first?.description.capitalized ?? "No description"
            
            // Create DailyWeather instance
            let dailyWeather = DailyWeather(date: date, tempMin: tempMin, tempMax: tempMax, description: description)
            dailyWeatherList.append(dailyWeather)
        }
        
        // Sort the weather list by date and return only the next 5 days
        return dailyWeatherList.sorted { $0.date < $1.date }.prefix(5).map { $0 }
    }
}

