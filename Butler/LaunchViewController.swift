//
//  LaunchViewController.swift
//  Butler
//
//  Created by Nirvana on 12/31/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    var launchShineLabel: RQShineLabel!
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        launchShineLabel = RQShineLabel(frame: CGRect(x: 16, y: 16, width: 320 - 32, height: CGRectGetHeight(self.view.bounds) - 16))
        launchShineLabel.numberOfLines = 0;
        launchShineLabel.font = UIFont(name: "HelveticaNeue-Light", size: 24)
        launchShineLabel.text = LaunchText.textArrayAtFirst[0]
        launchShineLabel.backgroundColor = UIColor.clearColor()
        launchShineLabel.sizeToFit()
        launchShineLabel.center = CGPoint(x: self.view.center.x, y: self.view.center.y/5*3.82)
        self.view.addSubview(launchShineLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.launchShineLabel.visible {
            self.launchShineLabel.fadeOutWithCompletion({ () -> Void in
                self.changeText()
                self.launchShineLabel.shine()
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.launchShineLabel.shine()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    /**
     获取下一条 LaunchText 中给定的文案
     */
    func changeText() {
        index++
        if index == LaunchText.textArrayAtFirst.count {
            self.launchShineLabel.text = ""
        } else {
            self.launchShineLabel.text = LaunchText.textArrayAtFirst[index]
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
