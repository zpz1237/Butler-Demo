//
//  MainModel.swift
//  Butler
//
//  Created by Nirvana on 1/3/16.
//  Copyright © 2016 NSNirvana. All rights reserved.
//

import Foundation

struct ContentModel {
    var id: Int
    var type: String
    var image: String
    var time: String
    var content: String
    var categoryType: String
}

struct MainText {
    static var sampleData: [ContentModel] = [

    ]
    
    static func transformDataToNotification(contentModel: ContentModel) -> UILocalNotification {
        func getTimeFromModel(time: String) -> (hour: Int, minute: Int) {
            let hour = Int(NSString(string: time).substringToIndex(2))
            let minute = Int(NSString(string: time).substringFromIndex(3))
            return (hour!, minute!)
        }
        
        let scheduleTime = getTimeFromModel(contentModel.time)
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([.Hour, .Minute, .Second], fromDate: date)
        
        let hour = comp.hour
        let minute = comp.minute
        let second = comp.second
        
        var delayTime: Double = 0
        let interval = Double((scheduleTime.hour - hour)*3600 - minute*60 + scheduleTime.minute*60 - second)
        
        if scheduleTime.hour > hour {
            delayTime = interval
        } else if scheduleTime.hour == hour && scheduleTime.minute > minute {
            delayTime = interval
        } else {
            delayTime = Double(24*3600 + interval)
        }
        
        let notificationFireDate = date.dateByAddingTimeInterval(delayTime)
        
        let notification = UILocalNotification()
        notification.alertTitle = contentModel.type
        notification.alertBody = NSString(string: contentModel.content).substringFromIndex(4)
        notification.category = contentModel.categoryType
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.fireDate = notificationFireDate
        notification.repeatInterval = NSCalendarUnit.Day
        notification.userInfo = ["index": contentModel.id]
        return notification
    }
    
    /**
     清除之前的通知，并根据此时 sampleData 的数据设置新通知
     */
    static func scheduleLocalNotification() {
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
    
}