//
//  WeatherObject.swift
//  WeatherApp
//
//  Created by Taavi Tuomela on 04/10/2018.
//  Copyright © 2018 Taavi Tuomela. All rights reserved.
//

import Foundation

struct WeatherObject: Decodable {
    
    let weather: [WeatherInfo]
    let main: WeatherMain
    let city: String
    
    enum CodingKeys : String, CodingKey {
        case weather
        case main
        case city = "name"
    }
}

struct WeatherInfo: Decodable {
    
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct WeatherMain: Decodable {
    
    let temp: Double
    let pressure: Int
    let humidity: Int
    let temp_min: Double
    let temp_max: Double
}
