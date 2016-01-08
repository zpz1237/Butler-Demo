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
    
    var titleLabel: LTMorphingLabel!
    var labelChangedTimer: NSTimer!
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel = LTMorphingLabel(frame: CGRect(x: 30, y: 30, width: self.view.bounds.width - 60, height: 50))
        titleLabel.center = CGPoint(x: self.view.center.x, y: self.titleImageView.center.y + 53)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = CommonModel.appleBlack
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 24)
        titleLabel.text = ""
        titleLabel.morphingEffect = .Evaporate
        self.view.addSubview(titleLabel)
        
        tableView.backgroundColor = CommonModel.zenGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.rowHeight = 100
        tableView.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.height)
        tableView.alpha = 0
        
        self.view.backgroundColor = CommonModel.zenGray
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        MainText.scheduleLocalNotification()
        
        self.labelChangedTimer = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: "changeText", userInfo: nil, repeats: true)
        self.labelChangedTimer.fire()
        self.tableView.userInteractionEnabled = false
        UIView.animateWithDuration(1.85, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0, options: .AllowUserInteraction, animations: { () -> Void in
            self.tableView.alpha = 1
            self.tableView.transform = CGAffineTransformIdentity
            }) { (finished) -> Void in
                
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let nav = segue.destinationViewController as? UINavigationController {
                if let vc = nav.topViewController as? DetailViewController {
                    vc.titleLabel.text = MainText.sampleData[self.tableView.indexPathForSelectedRow!.section].type
                    vc.date = MainText.transformDataToNotification(MainText.sampleData[self.tableView.indexPathForSelectedRow!.section]).fireDate!
                    vc.currentIndex = self.tableView.indexPathForSelectedRow!.section
                    vc.delegate = self
                }
            }
        }
    }
    
    /**
     隐藏 cell 的 rightUtilityButtons
     */
    func hideUtilityButtons() {
        (self.tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as! MainTableViewCell).hideUtilityButtonsAnimated(true)
    }
    
    /**
     获取下一条 LoginText 中给定的文案
     */
    func changeText() {
        index++
        if index == MainText.textArrayAtFirst.count {
            self.titleLabel.text = "愿意为您服务"
            performSelector("clearTextInTitleLabel", withObject: nil, afterDelay: 1.5)
            performSelector("moveTableViewUpward", withObject: nil, afterDelay: 2)
            self.tableView.userInteractionEnabled = true
            labelChangedTimer.invalidate()
        } else {
            self.titleLabel.text = MainText.textArrayAtFirst[index]
            if index == 3 {
                (self.tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as! MainTableViewCell).showRightUtilityButtonsAnimated(true)
                self.performSelector("hideUtilityButtons", withObject: nil, afterDelay: 2.25)
            }
        }
    }
    
    /**
     清空 titleLabel 文字信息
     */
    func clearTextInTitleLabel() {
        self.titleLabel.text = ""
    }
    
    /**
     使 tableView 上移遮住 titleLabel
     */
    func moveTableViewUpward() {
        UIView.animateWithDuration(0.85, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0, options: .AllowUserInteraction, animations: { () -> Void in
            self.tableView.transform = CGAffineTransformMakeTranslation(0, -53)
            }) { (finished) -> Void in
                
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mainCell") as! MainTableViewCell
        
        cell.delegate = self
        cell.rightUtilityButtons = self.rightButtons() as [AnyObject]
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

extension MainViewController: SWTableViewCellDelegate {
    func rightButtons() -> NSMutableArray {
        let rightUtilityButtons: NSMutableArray = []
        rightUtilityButtons.sw_addUtilityButtonWithColor(CommonModel.zenBlue, title: "好的")
        rightUtilityButtons.sw_addUtilityButtonWithColor(CommonModel.tieBlack, title: "稍后")
        rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor.lightGrayColor(), title: "忽略")
        return rightUtilityButtons
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        switch index {
        case 0:
            print("ok")
        case 1:
            print("later")
        case 2:
            print("ignore")
        default:
            ()
        }
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
