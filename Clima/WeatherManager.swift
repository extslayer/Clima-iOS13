//
//  WeatherManager.swift
//  Clima
//
//  Created by Manmohan Shrivastava on 16/11/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager : WeatherManager,weather: WeatherModel)
    func didFailWithError(error : Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=0b17eeca625632e9920e3365aaf7ab0c&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    
    
    
    func fetchWeather(cityName : String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func fetchWeatherUsingCordinates(latitude : CLLocationDegrees, longitude : CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(latitude)"
        performRequest(urlString: urlString)
        
    }
    
    func performRequest(urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = self.parseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        
                        
                    }
                }
            }
            task.resume()
            
            
        }
    }
    
    func parseJSON(weatherData : Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            print(name)
            let weatherModel = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weatherModel
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
        
    }
    
    
    
    
    
}
