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
        
        self.view.backgroundColor = CommonModel.zenGray
        self.slidingView.backgroundColor = CommonModel.zenGray
        
        accountTF.tintColor = CommonModel.appleBlack
        accountTF.textColor = CommonModel.appleBlack
        passwordTF.tintColor = CommonModel.appleBlack
        passwordTF.textColor = CommonModel.appleBlack
        accountTF.delegate = self
        passwordTF.delegate = self

        enterButton.layer.cornerRadius = 3
        enterButton.backgroundColor = CommonModel.appleBlack
        
        titleLabel = LTMorphingLabel(frame: CGRect(x: 30, y: 30, width: self.view.bounds.width - 60, height: 50))
        titleLabel.center = CGPoint(x: self.view.center.x, y: self.view.center.y/5*1.9776)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = CommonModel.appleBlack
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
        return .Default
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepared")
    }
    
    @IBAction func enterButtonAction(sender: UIButton) {
        guard accountTF.text != "" && passwordTF.text != "" else {
            self.titleLabel.text = LoginText.invalidInfoA
            performSelector("clearTextInTitleLabel", withObject: nil, afterDelay: 1.5)
            return
        }
        if accountTF.text == LoginText.tempAccount && passwordTF.text == LoginText.tempPassword {
            self.titleLabel.text = LoginText.successInfo
            performSelector("clearTextInTitleLabel", withObject: nil, afterDelay: 1.5)
            performSelector("invokeSegue", withObject: nil, afterDelay: 2)
        } else {
            self.titleLabel.text = LoginText.invalidInfoB
            performSelector("clearTextInTitleLabel", withObject: nil, afterDelay: 1.5)
        }
    }
    
    /**
     触发转场
     */
    func invokeSegue() {
        self.performSegueWithIdentifier("showMain", sender: nil)
    }
    
    /**
     清空 titleLabel 文字信息
     */
    func clearTextInTitleLabel() {
        self.titleLabel.text = ""
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
