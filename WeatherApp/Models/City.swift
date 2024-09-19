//
//  City.swift
//  WeatherApp
//
//  Created by Shubham Gupta on 19/09/24.
//

import Foundation

struct City: Decodable {
    let name: String
    let country: String
    let state: String
    let lat: Double
    let lon: Double
}

