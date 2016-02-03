//
//  WeatherTableViewCell.swift
//  Butler
//
//  Created by Nirvana on 1/31/16.
//  Copyright © 2016 NSNirvana. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var contentLabel: myUILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var accessoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentLabel.verticalAlignment = VerticalAlignmentMiddle
        contentLabel.textColor = CommonModel.appleBlack
        
        self.contentView.backgroundColor = CommonModel.zenGray
        
        let selectedView = UIView(frame: self.contentView.frame)
        selectedView.backgroundColor = CommonModel.zenGray
        self.selectedBackgroundView = selectedView
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
