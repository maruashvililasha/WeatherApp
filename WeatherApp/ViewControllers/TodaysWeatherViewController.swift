//
//  ViewController.swift
//  WeatherApp
//
//  Created by Lasha Maruashvili on 06.02.21.
//

import UIKit
import CoreLocation
import Kingfisher

class TodaysWeatherViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var mainIconImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    //stats
    @IBOutlet weak var chanceOfRainLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var directionOfSomethingLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    
    let linkToShare = "Description you want.."
    let items = [URL(string: "https://github.com/maruashvililasha/WeatherApp")!]
    
    var weather: CurrentWeatherResponse? {
        didSet {
            print("Current Weather Updated")
            self.setupUI()
        }
    }
    private var locationManager : CLLocationManager?
    let weatherApi = WeatherApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainStackView.alpha = 0
        logoImageView.alpha = 1
        weatherApi.delegate = self
        self.title = "Today"
        getUserLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getWeather()
    }
    
    private func getWeather() {
        if let location = Util.currentLocation {
            let lat = "\(location.coordinate.latitude)"
            let lon = "\(location.coordinate.longitude)"
            weatherApi.getTodaysWeather(lat: lat, lon: lon)
        }
    }
    
    private func getUserLocation() {
        locationManager = CLLocationManager()
        guard hasLocationPermission() else {
            Util.ask(UIViewController: self, title: "Location services", message: "Location permission is not granted, please grant permission for the app to function. thank you!") {
                self.locationManager?.requestAlwaysAuthorization()
                self.locationManager?.delegate = self
                self.locationManager?.startUpdatingLocation()
            }
            return
        }
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
    }
    
    private func hasLocationPermission() -> Bool {
        var hasPermission = false
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                hasPermission = false
            case .authorizedAlways, .authorizedWhenInUse:
                hasPermission = true
            @unknown default:
                hasPermission = false
            }
        } else {
            hasPermission = false
        }
        
        return hasPermission
    }
    
    private func setupUI() {
        guard let weather = weather else {
            errorUI()
            return
        }
        mainIconImageView.kf.setImage(with: Util.getIconUrl(icon: weather.weather.first!.icon))
        locationLabel.text = "\(weather.name), \(weather.sys.country)"
        temperatureLabel.text = "\(weather.main.temp)° | \(weather.weather.first!.weatherDescription.capitalized)"
        chanceOfRainLabel.text = "48%" // ეს დეითა ვერ ვნახე :/
        windSpeedLabel.text = "\(weather.wind.speed) km/h"
        humidityLabel.text = "\(weather.main.humidity)%"
        directionOfSomethingLabel.text = "S" // ესეც
        pressureLabel.text = "\(weather.main.pressure) hPa"
        if  mainStackView.alpha == 0 {
            UIView.animate(withDuration: 1) {
                self.mainStackView.alpha = 1
                self.logoImageView.alpha = 0
            }
        }
    }
    
    private func errorUI() {
        UIView.animate(withDuration: 1) {
            self.mainStackView.alpha = 0
            self.logoImageView.alpha = 1
        }
    }
    
    
    @IBAction func shareButtonDidTap(_ sender: Any) {
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(ac, animated: true, completion: nil)
    }
    
}

extension TodaysWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            if Util.currentLocation == nil {
                Util.currentLocation = location
                self.getWeather()
            } else {
                Util.currentLocation = location
            }
            
        }
    }
}

extension TodaysWeatherViewController: WeatherApiDelegate {
    func todaysWeatherError() {
        Util.prompt(UIViewController: self, title: "oh!", message: "We are having trouble, please try again later")
        DispatchQueue.main.async {
            self.errorUI()
        }
    }
    
    func todaysWeatherSuccess(weather: CurrentWeatherResponse) {
        DispatchQueue.main.async {
            self.weather = weather
        }
    }
}
