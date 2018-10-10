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
    let dt_txt: String?
    let name: String?

    enum CodingKeys : String, CodingKey {
        case main
        case weather
        case dt_txt
        case name
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
