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
    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var slidingView: UIView!
    
    var titleLabel: LTMorphingLabel!
    var labelChangedTimer: NSTimer!
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.slidingView.backgroundColor = CommonModel.mainColor
        
        accountTF.tintColor = UIColor.whiteColor()
        accountTF.textColor = UIColor.whiteColor()
        passwordTF.tintColor = UIColor.whiteColor()
        passwordTF.textColor = UIColor.whiteColor()
        accountTF.delegate = self
        passwordTF.delegate = self
        
        enterButton.layer.cornerRadius = 3
        
        titleLabel = LTMorphingLabel(frame: CGRect(x: 30, y: 30, width: self.view.bounds.width - 60, height: 50))
        titleLabel.center = CGPoint(x: self.view.center.x, y: self.view.center.y/5*1.9776)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 24)
        titleLabel.text = LoginText.textArray[index]
        titleLabel.morphingEffect = .Evaporate
        self.view.addSubview(titleLabel)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "keyboardShow:",
            name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "keyboardHide:",
            name: UIKeyboardWillHideNotification, object: nil)
        
        self.labelChangedTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "changeText", userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.labelChangedTimer.fire()
        self.accountTF.becomeFirstResponder()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    /**
     获取下一条 LoginText 中给定的文案
     */
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {

    }
                
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardShow(n:NSNotification) {
        UIView.animateWithDuration(0.25) { () -> Void in
            self.slidingView.transform = CGAffineTransformMakeTranslation(0, -49)
        }
    }
    
    func keyboardHide(n:NSNotification) {
        UIView.animateWithDuration(0.25) { () -> Void in
            self.slidingView.transform = CGAffineTransformIdentity
        }
    }
}
