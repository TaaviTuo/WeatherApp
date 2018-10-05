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
    let name: String
    let dt_txt: String?

    enum CodingKeys : String, CodingKey {
        case weather
        case main
        case name
        case dt_txt
    }
}

struct WeatherInfo: Decodable {
    
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    enum CodingKeys : String, CodingKey {
        case id
        case main
        case description
        case icon
    }
}

struct WeatherMain: Decodable {
    
    let temp: Double
    
    enum CodingKeys : String, CodingKey {
        case temp
    }
}
