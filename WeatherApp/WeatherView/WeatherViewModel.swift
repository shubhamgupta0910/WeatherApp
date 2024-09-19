//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Shubham Gupta on 19/09/24.
//

import Foundation

class WeatherViewModel {
    let apiKey = "429f49c804ceb7433e9f3c5fe4075c91"
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
    
    func fetchWeatherData(city: City) {
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(city.lat)&lon=\(city.lon)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            onError?("Invalid URL")
            return
        }
        
        // Fetch weather data
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                self?.onError?("Error fetching weather data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.weatherResponse = weatherResponse
                }
            } catch {
                DispatchQueue.main.async {
                    self?.onError?("Error parsing weather data: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func fetchDailyWeather(city: City) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(city.lat)&lon=\(city.lon)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            onError?("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                self?.onError?("Error fetching weather data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let forecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
                
                // Process the data to get daily weather
                let dailyWeather = self?.processDailyWeather(forecastResponse)
                
                DispatchQueue.main.async {
                    self?.dailyWeather = dailyWeather ?? []
                }
            } catch {
                DispatchQueue.main.async {
                    self?.onError?("Error parsing weather data: \(error.localizedDescription)")
                }
            }
        }.resume()
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

