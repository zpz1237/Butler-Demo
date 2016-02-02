//
//  AppDelegate.swift
//  Butler
//
//  Created by Nirvana on 12/31/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let sB = UIStoryboard(name: "Main", bundle: nil)
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey(CommonModel.firstLaunchKey) {
            
            self.window?.rootViewController = sB.instantiateViewControllerWithIdentifier("MainVCNV")
        } else {
            
            self.window?.rootViewController = sB.instantiateViewControllerWithIdentifier("LaunchVC")
            initializeDatabase()
            NSUserDefaults.standardUserDefaults().setObject("NotFirstLaunch", forKey: CommonModel.firstLaunchKey)
        }
        
        retrieveData()
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
        categoryType2.setActions([remindAction15, remindAction5], forContext: .Default)
        categoryType2.setActions([remindAction15, remindAction5], forContext: .Minimal)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes:([UIUserNotificationType.Sound, UIUserNotificationType.Alert, UIUserNotificationType.Badge]) , categories: NSSet(array: [categoryType1, categoryType2]) as? Set<UIUserNotificationCategory>))
    }
    
    /**
     初始化数据库
     */
    func initializeDatabase() {
        let realm = try! Realm()
        
        realm.beginWrite()
        realm.add(ContentModel(id: 0, type: "天气", image: "Sun", time: "08:00", content: "    起床啦 起床啦 愿您的心情像天气一样好。", categoryType: "CATEGORY_TYPE2"))
        realm.add(ContentModel(id: 1, type: "午餐", image: "Lunch", time: "11:00", content: "    我们根据您的口味为您特意挑选了午餐，点击查看。", categoryType: "CATEGORY_TYPE1"))
        realm.add(ContentModel(id: 2, type: "健康", image: "Health", time: "22:00", content: "    您今天的健康目标完成了吗。", categoryType: "CATEGORY_TYPE1"))
        realm.add(ContentModel(id: 3, type: "晚餐", image: "Dinner", time: "17:00", content: "    晚餐已为您选好，点击查看。", categoryType: "CATEGORY_TYPE1"))
        realm.add(ContentModel(id: 4, type: "睡眠", image: "Sleep", time: "23:00", content: "    早睡早起身体好。", categoryType: "CATEGORY_TYPE2"))
        try! realm.commitWrite()
    }
    
    /**
     从数据库中读取数据到内存
     */
    func retrieveData() {
        let realm = try! Realm()
        
        let results = realm.objects(ContentModel)
        for result in results {
            MainText.notificationData.append(result)
        }
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
            print(application.scheduledLocalNotifications)
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

