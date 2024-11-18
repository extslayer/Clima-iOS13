//
//  WeatherData.swift
//  Clima
//
//  Created by Manmohan Shrivastava on 17/11/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable{
    let name : String
    let weather : [Weather]
    let main : Main
    
}

struct Main: Decodable {
    let temp : Double
    let feels_like : Double
    let temp_min : Double
    let temp_max : Double
    let pressure : Int
    let humidity : Int
}

struct Weather: Decodable {
    let id : Int
    let main : String
    let description : String
}
