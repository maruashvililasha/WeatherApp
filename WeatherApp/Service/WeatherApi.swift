//
//  WeatherApi.swift
//  WeatherApp
//
//  Created by Lasha Maruashvili on 06.02.21.
//

import Foundation

class WeatherApi {
    
    weak var delegate: WeatherApiDelegate?
    
    private let apiKey = "fb08e637e13e9595582a771d348ab630"
    private let scheme = "https"
    private let host = "api.openweathermap.org"
    
    
    func getTodaysWeather(lat: String, lon: String) {
        let session = URLSession.shared
        var urlBuilder = URLComponents()
        urlBuilder.scheme = scheme
        urlBuilder.host = host
        urlBuilder.path = "/data/2.5/weather"
        urlBuilder.queryItems = [
            URLQueryItem(name: "lat", value: lat),
            URLQueryItem(name: "lon", value: lon),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        
        let url = urlBuilder.url!
        
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                self.delegate?.todaysWeatherError()
                return
            }
            do {
                let todaysWeatherResponce : CurrentWeatherResponse = try JSONDecoder().decode(CurrentWeatherResponse.self, from: data!)
                self.delegate?.todaysWeatherSuccess(weather: todaysWeatherResponce)
            } catch {
                print("JSON error: \(error.localizedDescription)")
                self.delegate?.todaysWeatherError()
            }
        }
        task.resume()
    }
    
    func getForecast(lat: String, lon: String) {
        let session = URLSession.shared
        var urlBuilder = URLComponents()
        urlBuilder.scheme = scheme
        urlBuilder.host = host
        urlBuilder.path = "/data/2.5/forecast"
        urlBuilder.queryItems = [
            URLQueryItem(name: "lat", value: lat),
            URLQueryItem(name: "lon", value: lon),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        
        let url = urlBuilder.url!
        
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                self.delegate?.forecastError()
                return
            }
            do {
                let forecastResponce : ForecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data!)
                self.delegate?.forecastSuccess(forecast: forecastResponce)
            } catch {
                print("JSON error: \(error.localizedDescription)")
                self.delegate?.forecastError()
            }
        }
        task.resume()
    }
}
