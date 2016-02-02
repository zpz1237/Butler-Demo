//
//  CommonModel.swift
//  Butler
//
//  Created by Nirvana on 1/1/16.
//  Copyright © 2016 NSNirvana. All rights reserved.
//

import Foundation

struct CommonModel {
    static let zenGray = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
    static let tieBlack = UIColor(red: 81/255.0, green: 81/255.0, blue: 81/255.0, alpha: 1)
    static let appleBlack = UIColor(red: 48/255.0, green: 48/255.0, blue: 48/255.0, alpha: 1)
    static let zenBlue = UIColor(red: 115/255.0, green: 125/255.0, blue: 150/255.0, alpha: 1)
    static let firstLaunchKey = "firstLaunchKey"
}

extension UINavigationController {
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if let barStyle = self.topViewController?.preferredStatusBarStyle() {
            return barStyle
        }
        return .Default
    }
    public override func prefersStatusBarHidden() -> Bool {
        if let hidden = self.topViewController?.prefersStatusBarHidden() {
            return hidden
        }
        return false
    }
}