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
    
    var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = CommonModel.zenGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.rowHeight = 120
        
        self.view.backgroundColor = CommonModel.zenGray
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1)
        self.navigationController?.navigationBar.translucent = false
        
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
                    if let index = self.tableView.indexPathForSelectedRow?.row {
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
        let data = MainText.notificationData[indexPath.row]
        
        if data.type == "天气" {
            let cell = tableView.dequeueReusableCellWithIdentifier("weatherCell") as! WeatherTableViewCell
            cell.temperatureLabel.text = "7"
            cell.weatherImageView.image = UIImage(named: data.image)
            cell.contentLabel.text = data.content
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("mealCell") as! MealTableViewCell
        cell.typeLabel.text = data.type
        cell.mealImageView.image = UIImage(named: data.image)
        cell.contentLabel.text = data.content
        
//        cell.notificationType.text = MainText.notificationData[indexPath.section].type
//        cell.notificationImageView.image = UIImage(named: MainText.notificationData[indexPath.section].image)
//        cell.notificationTimeLabel.text = MainText.notificationData[indexPath.section].time
//        cell.notificationContentLabel.text = MainText.notificationData[indexPath.section].content
        
//        cell.weatherImageView.image = UIImage(named: MainText.notificationData[indexPath.section].image)
//        cell.contentLabel.text = MainText.notificationData[indexPath.section].content
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //performSegueWithIdentifier("showDetail", sender: nil)
        selectedIndexPath = indexPath
        //performSegueWithIdentifier("showWeather", sender: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainText.notificationData.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}

extension MainViewController: DetailViewControllerDelegate {
    /**
     根据选中的时间更新数据库 以及更新 view 和 localNotification
     
     - parameter modifiedDate: 设置页面所选中的时间
     - parameter selectedRow: 之前选中的 Row
     */
    func updateData(modifiedDate: NSDate, selectedRow: Int) {
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
            MainText.notificationData[selectedRow].time = timeString
        }
        
        //待修改
        self.tableView.reloadSections(NSIndexSet(index: selectedRow), withRowAnimation: .Automatic)
        MainText.scheduleLocalNotification()
    }
}

extension MainViewController: ExpandingTransitionPresentingViewController {
    func expandingTransitionTargetViewForTransition(transition: ExpandingCellTransition) -> UIView! {
        if let indexPath = selectedIndexPath {
            return tableView.cellForRowAtIndexPath(indexPath)
        }
        else {
            return nil
        }
    }
}
