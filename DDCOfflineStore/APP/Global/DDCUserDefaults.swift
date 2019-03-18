//
//  DDCUserDefaults.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation

class DDCUserDefaults: NSObject{

    class func setObject(object: AnyObject,key: String) {
        UserDefaults.standard.set(object, forKey: key)
        let userDefaults: UserDefaults = UserDefaults.init(suiteName:         DDCStore.Keys.DDC_Device_SUITENAME)!
        userDefaults.set(object, forKey: DDCStore.Keys.DDC_Device_SUITENAME)
    }
    
    class func objectForKey(key: String) -> Any {
        let userDefaults: UserDefaults = UserDefaults.init(suiteName:         DDCStore.Keys.DDC_Device_SUITENAME)!
        if let object = userDefaults.object(forKey: key) {
            return object
        }
        return  UserDefaults.standard.object(forKey: key) as Any
    }

    class func synchronize() {
        UserDefaults.standard.synchronize()
        let userDefaults: UserDefaults = UserDefaults.init(suiteName:         DDCStore.Keys.DDC_Device_SUITENAME)!
        userDefaults.synchronize()
    }

}
