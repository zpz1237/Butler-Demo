//
//  LaunchViewController.swift
//  Butler
//
//  Created by Nirvana on 12/31/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var transitionButton: UIButton!
    
    var launchShineLabel: RQShineLabel!
    let transition = BubbleTransition()
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = CommonModel.mainColor
        
        transitionButton.alpha = 0
        transitionButton.layer.cornerRadius = transitionButton.bounds.height/2
        transitionButton.adjustsImageWhenHighlighted = false
        
        launchShineLabel = RQShineLabel(frame: CGRect(x: 16, y: 16, width: 320 - 32, height: CGRectGetHeight(self.view.bounds) - 16))
        launchShineLabel.numberOfLines = 0;
        launchShineLabel.font = UIFont(name: "HelveticaNeue-Light", size: 24)
        launchShineLabel.text = LaunchText.textArrayAtFirst[index]
        launchShineLabel.backgroundColor = UIColor.clearColor()
        launchShineLabel.sizeToFit()
        launchShineLabel.center = CGPoint(x: self.view.center.x, y: self.view.center.y/5*3.82)
        launchShineLabel.textAlignment = .Center
        self.view.addSubview(launchShineLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.launchShineLabel.visible {
            if index != LaunchText.textArrayAtFirst.count - 1 {
                self.launchShineLabel.fadeOutWithCompletion({ () -> Void in
                    self.changeText()
                    self.launchShineLabel.shine()
                })
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.launchShineLabel.shine()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .Custom
    }
    
    /**
     获取下一条 LaunchText 中给定的文案，并为转场做准备
     */
    func changeText() {
        index++
        if index == LaunchText.textArrayAtFirst.count {
            self.launchShineLabel.text = ""
        } else {
            if index == LaunchText.textArrayAtFirst.count - 1 {
                UIView.animateWithDuration(2.5, animations: { () -> Void in
                    self.transitionButton.alpha = 1
                })
            }
            self.launchShineLabel.text = LaunchText.textArrayAtFirst[index]
        }
    }
}

extension LaunchViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.startingPoint = transitionButton.center
        transition.bubbleColor = transitionButton.backgroundColor!
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
