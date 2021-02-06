//
//  ForecastResponce.swift
//  WeatherApp
//
//  Created by Lasha Maruashvili on 06.02.21.
//

import Foundation

// MARK: - ForecastResponse
class ForecastResponse: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City

    init(cod: String, message: Int, cnt: Int, list: [List], city: City) {
        self.cod = cod
        self.message = message
        self.cnt = cnt
        self.list = list
        self.city = city
    }
}

// MARK: - City
class City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int

    init(id: Int, name: String, coord: Coord, country: String, population: Int, timezone: Int, sunrise: Int, sunset: Int) {
        self.id = id
        self.name = name
        self.coord = coord
        self.country = country
        self.population = population
        self.timezone = timezone
        self.sunrise = sunrise
        self.sunset = sunset
    }
}

// MARK: - List
class List: Codable {
    let dt: Int
    let main: MainClass
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let dtTxt: String
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop
        case dtTxt = "dt_txt"
        case rain
    }

    init(dt: Int, main: MainClass, weather: [Weather], clouds: Clouds, wind: Wind, visibility: Int, pop: Double, sys: Sys, dtTxt: String, rain: Rain?) {
        self.dt = dt
        self.main = main
        self.weather = weather
        self.clouds = clouds
        self.wind = wind
        self.visibility = visibility
        self.pop = pop
        self.dtTxt = dtTxt
        self.rain = rain
    }
}


// MARK: - MainClass
class MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }

    init(temp: Double, feelsLike: Double, tempMin: Double, tempMax: Double, pressure: Int, seaLevel: Int, grndLevel: Int, humidity: Int, tempKf: Double) {
        self.temp = temp
        self.feelsLike = feelsLike
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.pressure = pressure
        self.seaLevel = seaLevel
        self.grndLevel = grndLevel
        self.humidity = humidity
        self.tempKf = tempKf
    }
}

// MARK: - Rain
class Rain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }

    init(the3H: Double) {
        self.the3H = the3H
    }
}


enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightRain = "light rain"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
}
