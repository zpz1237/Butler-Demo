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
        
        scheduleLocalNotification()
        
        self.labelChangedTimer = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: "changeText", userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.labelChangedTimer.fire()
        UIView.animateWithDuration(1.85, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0, options: .AllowUserInteraction, animations: { () -> Void in
            self.tableView.alpha = 1
            self.tableView.transform = CGAffineTransformIdentity
            }) { (finished) -> Void in

        }
    }
    
    /**
     清除之前的通知，并根据此时 sampleData 的数据设置新通知
     */
    func scheduleLocalNotification() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        let notificationFromSampleData = [
            MainText.transformDataToNotification(MainText.sampleData[0]),
            MainText.transformDataToNotification(MainText.sampleData[1]),
            MainText.transformDataToNotification(MainText.sampleData[2]),
            MainText.transformDataToNotification(MainText.sampleData[3]),
            MainText.transformDataToNotification(MainText.sampleData[4])
        ]
        
        for i in 0 ..< notificationFromSampleData.count {
            UIApplication.sharedApplication().scheduleLocalNotification(notificationFromSampleData[i])
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
