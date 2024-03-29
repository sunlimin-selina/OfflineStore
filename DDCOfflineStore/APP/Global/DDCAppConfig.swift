//
//  DDCAppConfig.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/10.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import UIKit

typealias screen = DDCAppConfig.screen

class DDCAppConfig: NSObject {
    static let kBarHeight: CGFloat = 60.0
    static let kLeftMargin: CGFloat = 134.0
    static let width = screen.width - kLeftMargin * 2
    
    struct screen {
        static let width: CGFloat = UIScreen.main.bounds.width
        static let height: CGFloat = UIScreen.main.bounds.height
        static let statusBarHeight: CGFloat = 20.0
        static let tabbarHeight: CGFloat = 49.0
        static let navigationBarHeight: CGFloat = 44.0
        static let X_Scale: CGFloat = width / 768
        static let Y_Scale: CGFloat = height / 1024
    }

}
