//
//  DDCKeyboardStateListener.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/10.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation

class DDCKeyboardStateListener {
    static let instance: DDCKeyboardStateListener = DDCKeyboardStateListener()
    class func sharedStore() -> DDCKeyboardStateListener {
        return instance
    }
    
    var isVisible: Bool = false
    
}
