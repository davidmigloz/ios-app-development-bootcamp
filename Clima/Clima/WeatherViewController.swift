//
//  ViewController.swift
//  WeatherApp
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {

    //Constants
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "xxx"
    
    // Members
    let locationManager = CLLocationManager()
    let weatherData = WeatherDataModel()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    func getWeatherDataByCoordinates(latitude: String, longitude: String) {
        let params : [String : String] = ["lat": latitude, "lon": longitude, "appid": APP_ID]
        getWeatherData(params: params)
    }
    
    func getWeatherDataByCity(city: String) {
        let params : [String : String] = ["q": city, "appid": APP_ID]
        getWeatherData(params: params)
    }
    
    func getWeatherData(params : [String : String]) {
        Alamofire.request(WEATHER_URL, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success:
                self.updateWeatherData(weatherJson: JSON(response.result.value!))
            case .failure(let error):
                print(error)
                self.cityLabel.text = "Connection issues!"
            }
        }
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    func updateWeatherData(weatherJson : JSON) {
        if let temperature = weatherJson["main"]["temp"].double {
            weatherData.temperature = Int(temperature - 273.15)
            let condition = weatherJson["weather"][0]["id"].intValue
            weatherData.condition = condition
            weatherData.weatherIconName = weatherData.updateWeatherIcon(condition: condition)
            weatherData.city = weatherJson["name"].stringValue
            updateUIWithWeatherData()
        }
    }
    
    //MARK: - UI Updates
    /***************************************************************/
    
    func updateUIWithWeatherData() {
        cityLabel.text = weatherData.city
        temperatureLabel.text = "\(weatherData.temperature)°"
        weatherIcon.image = UIImage(named: weatherData.weatherIconName)
    }
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if(location.horizontalAccuracy > 0) {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            getWeatherDataByCoordinates(latitude: String(location.coordinate.latitude),
                                        longitude: String(location.coordinate.longitude))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location unavailable!"
    }

    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    func userEnteredANewCity(city: String) {
        getWeatherDataByCity(city: city)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
}
