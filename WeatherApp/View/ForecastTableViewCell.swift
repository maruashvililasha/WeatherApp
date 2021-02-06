//
//  ForecastTableViewCell.swift
//  WeatherApp
//
//  Created by Lasha Maruashvili on 06.02.21.
//

import UIKit
import Kingfisher

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var celsiusLabel: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(data: List) {
        if let iconUrl = Util.getIconUrl(icon: data.weather.first!.icon) {
            iconImageView.kf.setImage(with: iconUrl)
        }
        timeLabel.text = Util.getTimeFromTS(timeStampInt: data.dt)
        stateLabel.text = data.weather.first!.weatherDescription.capitalized
        celsiusLabel.text = "\(Int(data.main.temp.rounded()))°C"
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
