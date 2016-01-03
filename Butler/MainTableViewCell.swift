//
//  MainTableViewCell.swift
//  Butler
//
//  Created by Nirvana on 1/3/16.
//  Copyright © 2016 NSNirvana. All rights reserved.
//

import UIKit

class MainTableViewCell: SWTableViewCell {

    @IBOutlet weak var notificationContentLabel: myUILabel!
    @IBOutlet weak var notificationType: UILabel!
    @IBOutlet weak var notificationImageView: UIImageView!
    @IBOutlet weak var notificationTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        notificationContentLabel.verticalAlignment = VerticalAlignmentTop
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
