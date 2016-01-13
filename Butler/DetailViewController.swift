//
//  DetailViewController.swift
//  Butler
//
//  Created by Nirvana on 1/7/16.
//  Copyright © 2016 NSNirvana. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate {
    func updateData(modifiedDate: NSDate, selectedSection: Int)
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelCircle: UIImageView!
    @IBOutlet weak var doneCircle: UIImageView!
    
    var date: NSDate!
    var currentIndex = -1
    var delegate: DetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        self.datePicker.backgroundColor = UIColor.whiteColor()
        
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        doneButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        doneCircle.image = UIImage(named: "Circle")?.imageWithRenderingMode(.AlwaysTemplate)
        doneCircle.tintColor = CommonModel.zenBlue
        cancelCircle.image = UIImage(named: "Circle")?.imageWithRenderingMode(.AlwaysTemplate)
        cancelCircle.tintColor = UIColor.lightGrayColor()
        
        self.view.backgroundColor = CommonModel.zenGray
        self.navigationController?.navigationBar.barTintColor = CommonModel.appleBlack
    }
    
    override func viewDidAppear(animated: Bool) {
        self.datePicker.setDate(date, animated: true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    @IBAction func cancelAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func DoneAction(sender: UIButton) {
        let modifiedDate = self.datePicker.date
        self.delegate?.updateData(modifiedDate, selectedSection: currentIndex)
        self.dismissViewControllerAnimated(true, completion: nil)
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

extension UINavigationController {
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if let barStyle = self.topViewController?.preferredStatusBarStyle() {
            return barStyle
        }
        return .Default
    }
}
