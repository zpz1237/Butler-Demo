//
//  AppDelegate.swift
//  Butler
//
//  Created by Nirvana on 12/31/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let sB = UIStoryboard(name: "Main", bundle: nil)
        if let isFirstLaunch = NSUserDefaults.standardUserDefaults().objectForKey(CommonModel.firstLaunchKey) {
            if (isFirstLaunch as! Bool) {
                self.window?.rootViewController = sB.instantiateViewControllerWithIdentifier("LaunchVC")
            } else {
                self.window?.rootViewController = sB.instantiateViewControllerWithIdentifier("MainVCNV")
            }
        } else {
            self.window?.rootViewController = sB.instantiateViewControllerWithIdentifier("LaunchVC")
            NSUserDefaults.standardUserDefaults().setObject(true, forKey: CommonModel.firstLaunchKey)
        }
        
        //记得写入
        if let sampleDataCached = NSUserDefaults.standardUserDefaults().objectForKey(CommonModel.sampleDataKey) {
            MainText.sampleData = sampleDataCached as! [ContentModel]
        } else {
            MainText.sampleData = [
                ContentModel(id: 0, type: "天气提醒", image: "Rain", time: "08:00", content: "    起床啦 起床啦。", categoryType: "CATEGORY_TYPE2"),
                ContentModel(id: 1, type: "午餐提醒", image: "Lunch", time: "11:00", content: "    您该准备吃午餐了。", categoryType: "CATEGORY_TYPE1"),
                ContentModel(id: 2, type: "晚餐提醒", image: "Dinner", time: "17:00", content: "    到了吃晚餐的时间了。", categoryType: "CATEGORY_TYPE1"),
                ContentModel(id: 3, type: "早餐预订", image: "Breakfast", time: "22:00", content: "    是否需要预定明天的早餐呢。", categoryType: "CATEGORY_TYPE1"),
                ContentModel(id: 4, type: "睡眠提醒", image: "Sleep", time: "23:00", content: "    您该休息了。", categoryType: "CATEGORY_TYPE2")
            ]
        }
        
        registerNotification()
        return true
    }

    /**
     注册本地系统通知
     
     */
    func registerNotification() {
        let detailAction = UIMutableUserNotificationAction()
        detailAction.identifier = "Detail"
        detailAction.title = "查看详情"
        detailAction.activationMode = .Foreground
        detailAction.destructive = false
        
        let remindAction5 = UIMutableUserNotificationAction()
        remindAction5.identifier = "REMIND5"
        remindAction5.title = "5分钟后"
        remindAction5.activationMode = .Background
        remindAction5.destructive = false
        
        let remindAction10 = UIMutableUserNotificationAction()
        remindAction10.identifier = "REMIND10"
        remindAction10.title = "10分钟后"
        remindAction10.activationMode = .Background
        remindAction10.destructive = false
        
        let remindAction15 = UIMutableUserNotificationAction()
        remindAction15.identifier = "REMIND15"
        remindAction15.title = "15分钟后"
        remindAction15.activationMode = .Background
        remindAction15.destructive = false
        
        let categoryType1 = UIMutableUserNotificationCategory()
        categoryType1.identifier = "CATEGORY_TYPE1"
        categoryType1.setActions([detailAction, remindAction10], forContext: .Default)
        categoryType1.setActions([detailAction, remindAction10], forContext: .Minimal)
        
        let categoryType2 = UIMutableUserNotificationCategory()
        categoryType2.identifier = "CATEGORY_TYPE2"
        categoryType2.setActions([remindAction5, remindAction15], forContext: .Default)
        categoryType2.setActions([remindAction5, remindAction15], forContext: .Minimal)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes:([UIUserNotificationType.Sound, UIUserNotificationType.Alert, UIUserNotificationType.Badge]) , categories: NSSet(array: [categoryType1, categoryType2]) as? Set<UIUserNotificationCategory>))
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print(notification.category)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        print(identifier)
        if identifier == "REMIND5" {
            notification.fireDate = NSDate().dateByAddingTimeInterval(300)
            notification.repeatInterval = NSCalendarUnit.Era
            application.scheduleLocalNotification(notification)
        } else if identifier == "REMIND10" {
            notification.fireDate = NSDate().dateByAddingTimeInterval(600)
            notification.repeatInterval = NSCalendarUnit.Era
            application.scheduleLocalNotification(notification)
        } else if identifier == "REMIND15" {
            notification.fireDate = NSDate().dateByAddingTimeInterval(900)
            notification.repeatInterval = NSCalendarUnit.Era
            application.scheduleLocalNotification(notification)
        } else if identifier == "Detail" {
            let sB = UIStoryboard(name: "Main", bundle: nil)
            let detailVCNV = sB.instantiateViewControllerWithIdentifier("DetailVCNV") as! UINavigationController
            let detailVC = detailVCNV.topViewController as! DetailViewController
            
            detailVC.titleLabel.text = notification.alertTitle
            detailVC.date = notification.fireDate
            detailVC.currentIndex = notification.userInfo!["index"] as! Int
            
            let mainVCNV = window!.rootViewController as! UINavigationController
            detailVC.delegate = mainVCNV.topViewController as! MainViewController
            
            window?.rootViewController?.presentViewController(detailVCNV, animated: true, completion: nil)
        } else {
            print("get the WRONG identifier")
        }
        
        completionHandler()
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

