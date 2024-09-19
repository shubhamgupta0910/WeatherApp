//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Shubham Gupta on 19/09/24.
//

import UIKit

class WeatherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var viewModel = WeatherViewModel()
    var city: City?
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.fetchWeatherData(city: city!)
        viewModel.fetchDailyWeather(city: city!)
    }
    
    // Bind ViewModel to the UI
    func bindViewModel() {
        // Handle weather data fetch success
        viewModel.onWeatherDataFetched = { [weak self] in
            guard let weather = self?.viewModel.weatherResponse else { return }
            self?.locationLabel.text = self?.city?.name
            self?.descLabel.text = weather.weather.first?.main
            self?.currentTemp.text = "\(weather.main.temp) °C"
            
            self?.humidityLabel.text = "Humidity: \(weather.main.humidity)%"
            self?.windSpeedLabel.text = "Wind Speed: \(weather.wind.speed) meter/sec"
        }
        
        viewModel.onDailyWeatherFetched = { [weak self] in
            self?.tableView.reloadData()
        }
        
        // Handle errors
        viewModel.onError = { error in
            print("Error: \(error)")
            // show an alert here
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dailyWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        let dailyWeather = viewModel.dailyWeather[indexPath.row]
        cell.textLabel?.text = dailyWeather.date
        cell.detailTextLabel?.text = "Min: \(dailyWeather.tempMin)°C, Max: \(dailyWeather.tempMax)°C, \(dailyWeather.description)"
        
        return cell
    }
}
