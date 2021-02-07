//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Lasha Maruashvili on 06.02.21.
//

import UIKit
import CoreLocation
import SnapKit

class ForecastViewController: UIViewController {
    
    @IBOutlet weak var forecastTableView: UITableView!
    
    let weatherApi = WeatherApi()
    var forecast: ForecastResponse? {
        didSet {
            print("Forecast Updated")
            self.orderData {
                forecastTableView.reloadData()
                setupUI()
            }
        }
    }
    
    var daily : [[List]] = []
    var sections : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Forecast"
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        weatherApi.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Api Call
        if let location = Util.currentLocation {
            let lat = "\(location.coordinate.latitude)"
            let lon = "\(location.coordinate.longitude)"
            weatherApi.getForecast(lat: lat, lon: lon)
        }
    }
    
    private func orderData(completion: ( ) -> Void) {
        daily = []
        sections = []
        guard let forecast = forecast else {return}
        var oneDay : [List] = []
        var day = Util.getDayFromTS(timeStampInt: forecast.list.first!.dt)
        sections.append("TODAY")
        for list in forecast.list {
            let listDay = Util.getDayFromTS(timeStampInt: list.dt)
            guard list.dt != forecast.list.last!.dt else {
                oneDay.append(list)
                daily.append(oneDay)
                completion()
                return
            }
            if listDay == day {
                oneDay.append(list)
            } else {
                day = listDay
                sections.append(listDay.uppercased())
                daily.append(oneDay)
                oneDay = []
            }
            
        }
    }
    
    private func setupUI() {
        self.title = self.forecast?.city.name
    }
}

extension ForecastViewController: WeatherApiDelegate {
    func forecastSuccess(forecast: ForecastResponse) {
        DispatchQueue.main.async {
            self.forecast = forecast
        }
    }
    func forecastError() {
        Util.prompt(UIViewController: self, title: "oh!", message: "We are having trouble, please try again later")
    }
}

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daily[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell") as! ForecastTableViewCell
        let data = daily[indexPath.section][indexPath.row]
        cell.seperatorView.isHidden = data.dt == daily[indexPath.section].last!.dt
        cell.configureCell(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let label = UILabel()
        let line1 = UIView()
        let line2 = UIView()
        if let _ = forecast {
            label.text = sections[section]
        } else {
            label.text = "No Data"
        }
        if #available(iOS 13.0, *) {
            headerView.backgroundColor = .systemBackground
            line1.backgroundColor = .tertiaryLabel
            line2.backgroundColor = .tertiaryLabel
            label.tintColor = .label
        } else {
            headerView.backgroundColor = .white
            line1.backgroundColor = .gray
            line2.backgroundColor = .gray
            label.tintColor = .black
        }
        headerView.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalToSuperview().inset(30)
        }
        headerView.addSubview(line1)
        line1.snp.makeConstraints { (maker) in
            maker.height.equalTo(0.5)
            maker.top.left.right.equalToSuperview()
        }
        headerView.addSubview(line2)
        line2.snp.makeConstraints { (maker) in
            maker.height.equalTo(0.5)
            maker.bottom.left.right.equalToSuperview()
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
