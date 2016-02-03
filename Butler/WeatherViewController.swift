//
//  WeatherViewController.swift
//  Butler
//
//  Created by Nirvana on 2/1/16.
//  Copyright © 2016 NSNirvana. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    let transition = ExpandingCellTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = transition
        self.view.backgroundColor = CommonModel.zenGray
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    @IBAction func cancelButtonClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
