//
//  Util.swift
//  WeatherApp
//
//  Created by Lasha Maruashvili on 06.02.21.
//

import UIKit
import CoreLocation
import Kingfisher

class Util {
    
    static var currentLocation: CLLocation?
    
    static func ask (UIViewController: UIViewController, title: String, message: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let noAction = UIAlertAction(title: "No", style: .cancel)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                DispatchQueue.main.async {
                    completion?()
                }
            }
            alertController.addAction(noAction)
            alertController.addAction(yesAction)
            UIViewController.present(alertController, animated: true)
        }
    }
    
    static func prompt(UIViewController: UIViewController, title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okAction)
            UIViewController.present(alertController, animated: true)
        }
    }
    
    static func getDayFromTS(timeStampInt: Int) -> String {
        let timeStampString = "\(timeStampInt)"
        guard let timeInterval = TimeInterval(timeStampString) else {
            return ""
        }
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    static func dateFallsInCurrentWeek(date: Date) -> Bool {
        let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
        let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
        return (currentWeek == datesWeek)
    }
    
    static func getTimeFromTS(timeStampInt: Int) -> String {
        let timeStampString = "\(timeStampInt)"
        guard let timeInterval = TimeInterval(timeStampString) else {
            return ""
        }
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    }
    
    static func getIconUrl(icon: String) -> URL? {
        return URL(string: "https://openweathermap.org/img/wn/\(icon).png")
    }
}
