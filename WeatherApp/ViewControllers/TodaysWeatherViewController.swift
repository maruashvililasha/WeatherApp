//
//  ViewController.swift
//  WeatherApp
//
//  Created by Lasha Maruashvili on 06.02.21.
//

import UIKit
import CoreLocation

class TodaysWeatherViewController: UIViewController {
    
    var weather: CurrentWeatherResponse? {
        didSet {
            print("Current Weather Updated")
        }
    }
    
    private var locationManager : CLLocationManager?
    
    let weatherApi = WeatherApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        print(CLLocationManager.locationServicesEnabled())
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
    
    deinit {
        print(self)
        print("deinit")
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
    }
    
    func todaysWeatherSuccess(weather: CurrentWeatherResponse) {
        DispatchQueue.main.async {
            self.weather = weather
        }
    }
}
