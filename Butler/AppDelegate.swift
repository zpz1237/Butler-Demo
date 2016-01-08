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
            let completeAction = UIMutableUserNotificationAction()
            completeAction.identifier = "OK" // the unique identifier for this action
            completeAction.title = "好的" // title for the action button
            completeAction.activationMode = .Background // UIUserNotificationActivationMode.Background - don't bring app to foreground
            completeAction.authenticationRequired = false // don't require unlocking before performing action
            completeAction.destructive = false // display action in red
            
            let remindAction = UIMutableUserNotificationAction()
            remindAction.identifier = "REMIND"
            remindAction.title = "稍后"
            remindAction.activationMode = .Background
            remindAction.destructive = false
            
            let todoCategory = UIMutableUserNotificationCategory() // notification categories allow us to create groups of actions that we can associate with a notification
            todoCategory.identifier = "TODO_CATEGORY"
            todoCategory.setActions([completeAction, remindAction], forContext: .Default) // UIUserNotificationActionContext.Default (4 actions max)
            todoCategory.setActions([completeAction, remindAction], forContext: .Minimal) // UIUserNotificationActionContext.Minimal - for when space is limited (2 actions max)
            
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes:([UIUserNotificationType.Sound, UIUserNotificationType.Alert, UIUserNotificationType.Badge]) , categories: NSSet(array: [todoCategory]) as? Set<UIUserNotificationCategory>))
        return true
    }

    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print(notification.category)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        print(identifier)
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

