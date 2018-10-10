//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Taavi Tuomela on 05/10/2018.
//  Copyright © 2018 Taavi Tuomela. All rights reserved.
//

import Foundation

struct ForecastModel: Decodable {
    
    let list: [WeatherObject]
    
    enum CodingKeys : String, CodingKey {
        case list
    }
    
    init() {
        
        self.list = []
    }
}
