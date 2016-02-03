//
//  MainModel.swift
//  Butler
//
//  Created by Nirvana on 1/3/16.
//  Copyright © 2016 NSNirvana. All rights reserved.
//

import Foundation
import RealmSwift

class WeatherTypeInfo: Object {
    dynamic var type: String = ""
    dynamic var temperature: String = ""
    dynamic var accessory: String = ""
    
    required convenience init(type: String, temperature: String, accessory: String) {
        self.init()
        self.type = type
        self.temperature = temperature
        self.accessory = accessory
    }
}

class ContentModel: Object {
    dynamic var id: Int = -1
    dynamic var type: String = ""
    dynamic var image: String = ""
    dynamic var time: String = ""
    dynamic var content: String = ""
    dynamic var cellType: Int = -1
    dynamic var categoryType: String = ""
    
    required convenience init(id: Int, type: String, image: String, time: String, content: String, cellType: Int,  categoryType: String) {
        self.init()
        self.id = id
        self.type = type
        self.image = image
        self.time = time
        self.content = content
        self.cellType = cellType
        self.categoryType = categoryType
    }
}

struct MainText {
    static var notificationData: [ContentModel] = [

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
        notification.alertBody = NSString(string: contentModel.content) as String
        notification.category = contentModel.categoryType
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.fireDate = notificationFireDate
        notification.repeatInterval = NSCalendarUnit.Day
        notification.userInfo = ["index": contentModel.id]
        return notification
    }
    
    /**
     清除之前的通知，并根据此时 notificationData 的数据设置新通知
     */
    static func scheduleLocalNotification() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        var notifications: [UILocalNotification] = []
        for i in 0 ..< MainText.notificationData.count {
            notifications.append(MainText.transformDataToNotification(MainText.notificationData[i]))
        }

        for i in 0 ..< notifications.count {
            UIApplication.sharedApplication().scheduleLocalNotification(notifications[i])
        }
    }
}