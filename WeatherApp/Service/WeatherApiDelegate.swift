//
//  WeatherApiDelegate.swift
//  WeatherApp
//
//  Created by Lasha Maruashvili on 06.02.21.
//

import Foundation

protocol WeatherApiDelegate: AnyObject {
    func todaysWeatherSuccess(weather: CurrentWeatherResponse)
    func todaysWeatherError()
    func forecastSuccess(forecast: ForecastResponse)
    func forecastError()
}

extension WeatherApiDelegate {
    func todaysWeatherSuccess(weather: CurrentWeatherResponse) {}
    func todaysWeatherError() {}
    func forecastSuccess(forecast: ForecastResponse) {}
    func forecastError() {}
}
