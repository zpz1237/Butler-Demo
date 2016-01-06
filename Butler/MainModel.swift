//
//  MainModel.swift
//  Butler
//
//  Created by Nirvana on 1/3/16.
//  Copyright © 2016 NSNirvana. All rights reserved.
//

import Foundation

struct ContentModel {
    var type: String
    var image: String
    var time: String
    var content: String
}

struct MainText {
    static var textArrayAtFirst = [
        "",
        "",
        "您会收到这样的通知",
        "左划回应",
        "右滑返回",
        "可处理的通知，都在这"
    ]
    
    static var sampleData = [
        ContentModel(type: "天气提醒", image: "Rain", time: "08:00", content: "    多云转中雨，4℃ ~ -2℃，注意保暖，出门请带伞。"),
        ContentModel(type: "午餐提醒", image: "Lunch", time: "11:00", content: "    到了吃午餐的时间了，我为您准备好了菜单。"),
        ContentModel(type: "晚餐提醒", image: "Dinner", time: "17:00", content: "    到了吃晚餐的时间了，菜单已为您准备好。"),
        ContentModel(type: "早餐预订", image: "Breakfast", time: "22:00", content: "    是否需要预定明天的早餐呢。"),
        ContentModel(type: "睡眠提醒", image: "Sleep", time: "23:00", content: "    如果您现在休息的话，我将于八小时后叫醒您。")
    ]
    
    static var notificationFromSampleData = [
        MainText.transformDataToNotification(MainText.sampleData[0]),
        MainText.transformDataToNotification(MainText.sampleData[1]),
        MainText.transformDataToNotification(MainText.sampleData[2]),
        MainText.transformDataToNotification(MainText.sampleData[3]),
        MainText.transformDataToNotification(MainText.sampleData[4])
    ]
    
    private static func transformDataToNotification(contentModel: ContentModel) -> UILocalNotification {
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
        notification.category = "TODO_CATEGORY"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.fireDate = notificationFireDate
        notification.repeatInterval = NSCalendarUnit.Day
        return notification
    }
    
}