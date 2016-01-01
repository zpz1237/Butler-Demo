//
//  LoginViewController.swift
//  Butler
//
//  Created by Nirvana on 12/31/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var enterButton: UIButton!
    
    var titleLabel: LTMorphingLabel!
    var labelChangedTimer: NSTimer!
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterButton.layer.cornerRadius = 3
        
        titleLabel = LTMorphingLabel(frame: CGRect(x: 30, y: 30, width: self.view.bounds.width - 60, height: 50))
        titleLabel.center = CGPoint(x: self.view.center.x, y: self.view.center.y/5*1.97)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = CommonModel.mainColor
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 24)
        titleLabel.text = LoginText.textArray[index]
        titleLabel.morphingEffect = .Evaporate
        self.view.addSubview(titleLabel)
        
        self.labelChangedTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "changeText", userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.labelChangedTimer.fire()
    }
    
    func changeText() {
        index++
        if index == LoginText.textArray.count {
            self.titleLabel.text = ""
            labelChangedTimer.invalidate()
        } else {
            self.titleLabel.text = LoginText.textArray[index]
        }
    }
}
