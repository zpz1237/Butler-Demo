//
//  MainViewController.swift
//  Butler
//
//  Created by Nirvana on 1/2/16.
//  Copyright © 2016 NSNirvana. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleImageView.image = scaleToSize(UIImage(named: "Bow-Tie")!, size: titleImageView.frame.size)
        
        tableView.backgroundColor = CommonModel.zenGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.rowHeight = 100
        
        self.view.backgroundColor = CommonModel.zenGray
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        MainText.scheduleLocalNotification()
        
        tableView.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.height)
        tableView.alpha = 0
        tableView.userInteractionEnabled = false
        
        if NSUserDefaults.standardUserDefaults().objectForKey(CommonModel.firstLaunchKey) as! Bool {
            animateTableViewWithDuration(1.25)
            NSUserDefaults.standardUserDefaults().setObject(false, forKey: CommonModel.firstLaunchKey)
        } else {
            animateTableViewWithDuration(1.25)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let nav = segue.destinationViewController as? UINavigationController {
                if let vc = nav.topViewController as? DetailViewController {
                    if let index = self.tableView.indexPathForSelectedRow?.section {
                        vc.titleLabel.text = MainText.sampleData[index].type
                        vc.date = MainText.transformDataToNotification(MainText.sampleData[index]).fireDate!
                        vc.currentIndex = index
                        vc.delegate = self
                    }
                }
            }
        }
    }
    
    /**
     根据时间生成 tableView 的出现动画
     
     - parameter duration: 持续时间
     */
    func animateTableViewWithDuration(duration: Double) {
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0, options: .AllowUserInteraction, animations: { () -> Void in
            self.tableView.alpha = 1
            self.tableView.transform = CGAffineTransformIdentity
            }) { (finished) -> Void in
                self.tableView.userInteractionEnabled = true
        }
    }
    
    /**
     重绘图片以消除锯齿
     
     - parameter image: 需重绘的图片
     - parameter size:  放置位置的大小
     
     - returns: 重绘后的图片
     */
    func scaleToSize(image: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mainCell") as! MainTableViewCell
        
        cell.notificationType.text = MainText.sampleData[indexPath.section].type
        cell.notificationImageView.image = UIImage(named: MainText.sampleData[indexPath.section].image)
        cell.notificationTimeLabel.text = MainText.sampleData[indexPath.section].time
        cell.notificationContentLabel.text = MainText.sampleData[indexPath.section].content
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showDetail", sender: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return MainText.sampleData.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 6
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 6))
        headerView.backgroundColor = CommonModel.zenGray
        return headerView
    }
}

extension MainViewController: DetailViewControllerDelegate {
    /**
     根据选中的时间设置 sampleDate 以及更新 view 和 localNotification
     
     - parameter modifiedDate: 设置页面所选中的时间
     - parameter selectedSection: 之前选中的 Section
     */
    func updateData(modifiedDate: NSDate, selectedSection: Int) {
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([.Hour, .Minute], fromDate: modifiedDate)
        
        var hour = NSString(string: String(comp.hour))
        var minute = NSString(string: String(comp.minute))
        var timeString = ""
        
        if minute.length == 1 {
            minute = (minute as String) + "0"
        }
        if hour.length == 1 {
            hour = "0" + (hour as String)
        }
        
        timeString = "\(hour)" + ":" + "\(minute)"
        
        MainText.sampleData[selectedSection].time = timeString

        self.tableView.reloadSections(NSIndexSet(index: selectedSection), withRowAnimation: .Automatic)
        MainText.scheduleLocalNotification()
    }
}
