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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentLabel.verticalAlignment = VerticalAlignmentMiddle
        contentLabel.textColor = CommonModel.appleBlack
        
        //添加分割线
//        let btmLine = UIView(frame: CGRectMake(15, 119.5, UIScreen.mainScreen().bounds.width - 15, 0.5))
//        btmLine.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        //self.contentView.addSubview(btmLine)
        
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
