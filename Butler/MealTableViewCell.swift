//
//  MealTableViewCell.swift
//  Butler
//
//  Created by Nirvana on 2/2/16.
//  Copyright © 2016 NSNirvana. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var contentLabel: myUILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mealImageView.contentMode = UIViewContentMode.ScaleAspectFill
        
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
