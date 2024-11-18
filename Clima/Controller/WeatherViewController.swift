//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    
    
    

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    var latitude: CLLocationDegrees = 40.7128
    var longitude: CLLocationDegrees = -74.0060
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherManager.delegate = self
        
        // Do any additional setup after loading the view.
        searchTextField.delegate = self
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
    
    

    
}

//MARK: - UITextFieldDelegate


extension WeatherViewController : UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: Any) {
        searchTextField.endEditing(true)
        searchTextField.endEditing(true)
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        searchTextField.endEditing(true)
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text! == "" {
            return true
        }else {
            textField.placeholder = "Enter a city"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
}

//MARK: - WeatherManagerDelegate


extension WeatherViewController: WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager : WeatherManager,weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = "\(weather.temperature)"
            self.cityLabel.text = weather.cityName
            print(weather.conditionName)
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(error: any Error) {
        print(error)
    }
    
}

//MARK: - CLLocationManagerDelegate


extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            weatherManager.fetchWeatherUsingCordinates(latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }

    
    
}

