//
//  MainViewController.swift
//  Butler
//
//  Created by Nirvana on 1/2/16.
//  Copyright © 2016 NSNirvana. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = CommonModel.zenGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.rowHeight = 120
        
        self.view.backgroundColor = CommonModel.zenGray
        self.navigationController?.navigationBar.barTintColor = CommonModel.appleBlack
        
        MainText.scheduleLocalNotification()
        
        tableView.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.height)
        tableView.alpha = 0
        
        animateTableViewWithDuration(1.25)
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let nav = segue.destinationViewController as? UINavigationController {
                if let vc = nav.topViewController as? DetailViewController {
                    if let index = self.tableView.indexPathForSelectedRow?.section {
                        vc.titleLabel.text = MainText.notificationData[index].type
                        vc.date = MainText.transformDataToNotification(MainText.notificationData[index]).fireDate!
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
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("weatherCell") as! WeatherTableViewCell
        
        cell.selected = false
        
//        cell.notificationType.text = MainText.notificationData[indexPath.section].type
//        cell.notificationImageView.image = UIImage(named: MainText.notificationData[indexPath.section].image)
//        cell.notificationTimeLabel.text = MainText.notificationData[indexPath.section].time
//        cell.notificationContentLabel.text = MainText.notificationData[indexPath.section].content
        
//        cell.weatherImageView.image = UIImage(named: MainText.notificationData[indexPath.section].image)
        cell.temperatureLabel.text = "7"
//        cell.contentLabel.text = MainText.notificationData[indexPath.section].content
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("clicked")
        //performSegueWithIdentifier("showDetail", sender: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return MainText.notificationData.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 1))
        headerView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        return headerView
    }
}

extension MainViewController: DetailViewControllerDelegate {
    /**
     根据选中的时间更新数据库 以及更新 view 和 localNotification
     
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
            minute = "0" + (minute as String)
        }
        if hour.length == 1 {
            hour = "0" + (hour as String)
        }
        
        timeString = "\(hour)" + ":" + "\(minute)"
        
        let realm = try! Realm()
        try! realm.write { () -> Void in
            MainText.notificationData[selectedSection].time = timeString
        }
        
        self.tableView.reloadSections(NSIndexSet(index: selectedSection), withRowAnimation: .Automatic)
        MainText.scheduleLocalNotification()
    }
}
