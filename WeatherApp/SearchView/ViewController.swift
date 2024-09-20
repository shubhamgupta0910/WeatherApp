//
//  ViewController.swift
//  WeatherApp
//
//  Created by Shubham Gupta on 19/09/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // UI Elements
    let searchTextField = UITextField()
    let resultsTableView = UITableView()
    
    // ViewModel
    var viewModel: SearchViewModel!
    
    // Data source
    var searchResults = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SearchViewModel(weatherService: WeatherService())
        
        // Setup UI
        setupUI()
        
        // Bind to ViewModel's completion handler
        setupBindings()
        
        // Delegate text field changes to self
        searchTextField.delegate = self
    }
    
    // Setup the UI for the text field and table view
    func setupUI() {
        // Setup UITextField
        searchTextField.frame = CGRect(x: 20, y: 100, width: self.view.frame.size.width - 40, height: 40)
        searchTextField.placeholder = "Enter city name"
        searchTextField.borderStyle = .roundedRect
        self.view.addSubview(searchTextField)
        
        // Setup UITableView
        resultsTableView.frame = CGRect(x: 20, y: 150, width: self.view.frame.size.width - 40, height: 400)
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        self.view.addSubview(resultsTableView)
    }
    
    // Setup bindings to ViewModel
    func setupBindings() {
        // When cities are fetched, update the table view
        viewModel.onCitiesFetched = { [weak self] cities in
            self?.searchResults = cities
            self?.resultsTableView.reloadData()
        }
        
        // Handle error case
        viewModel.onError = { error in
            print("Error fetching cities: \(error)")
        }
    }
    
    // Handle text field changes (searching as the user types)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if updatedText.count > 2 { // Avoid calling the API for very short queries
            viewModel.searchCities(query: updatedText)
        } else {
            searchResults.removeAll()
            resultsTableView.reloadData()
        }
        return true
    }
    
    // UITableView DataSource & Delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let city = searchResults[indexPath.row]
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = "\(city.state), \(city.country)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = searchResults[indexPath.row]
        searchTextField.text = selectedCity.name
        print("Selected City: \(selectedCity.name), Coordinates: \(selectedCity.lat), \(selectedCity.lon)")
        
        DispatchQueue.main.async {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let weatherViewController = storyBoard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
            weatherViewController.city = selectedCity
            self.navigationController?.pushViewController(weatherViewController, animated: true)
        }
        
    }
}
