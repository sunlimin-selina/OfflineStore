//
//  DDCStore.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import UIKit

class DDCStore : NSObject{
    
    static let instance: DDCStore = DDCStore()
    class func sharedStore() -> DDCStore {
        return instance
    }
    
    static let kUser : String = "User"

    struct AppId {
        static let buglyAppId = "000b731ad0"

    }
    
    struct Keys {
        static let DDC_Device_SUITENAME = "group.com.daydaycook.com"
        static let DDC_Device_IDFA_Key = "IDFA"
        static let DDC_Device_UUID_Key = "OpenUUID"
    }
    
    var user : DDCUserModel? {
        get {
            var _user: DDCUserModel?
            let userData = UserDefaults.standard.data(forKey: "DDCUser")
            if let _userData = userData {
                _user = (NSKeyedUnarchiver.unarchiveObject(with: _userData) as! DDCUserModel)
            }
            return _user
        }
        set {
            if let data = newValue {
                let userData : AnyObject = NSKeyedArchiver.archivedData(withRootObject: data as Any) as AnyObject
                UserDefaults.standard.set(userData, forKey: "DDCUser")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
}
