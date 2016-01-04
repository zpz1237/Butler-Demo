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
        "您会收到类似这样的通知",
        "左划进行回应",
        "右滑返回",
        "您可处理的通知，都会在这里"
    ]
    
    static var sampleData = [
        ContentModel(type: "天气提醒", image: "Rain", time: "08:00", content: "    多云转中雨，4℃ ~ -2℃，注意保暖，出门请带伞。")
    ]
    
    static func completeSampleData() {
        self.sampleData.append(ContentModel(type: "午餐提醒", image: "Lunch", time: "11:00", content: "    到了吃午餐的时间了，我为您准备好了菜单。"))
        self.sampleData.append(ContentModel(type: "晚餐提醒", image: "Dinner", time: "17:00", content: "    到了吃晚餐的时间了，菜单已为您准备好。"))
        self.sampleData.append(ContentModel(type: "早餐预订", image: "Breakfast", time: "22:00", content: "    是否需要预定明天的早餐呢。"))
        self.sampleData.append(ContentModel(type: "睡眠提醒", image: "Sleep", time: "23:00", content: "    如果您现在休息的话，我将于八小时后叫醒您。"))
    }
}