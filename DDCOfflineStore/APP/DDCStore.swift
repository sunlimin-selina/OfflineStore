//
//  DDCStore.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import UIKit

let screenWidth : CGFloat = UIScreen.main.bounds.width
let screenHeight : CGFloat = UIScreen.main.bounds.height

class DDCStore : NSObject{
    
    static let instance: DDCStore = DDCStore()
    class func sharedStore() -> DDCStore {
        return instance
    }
    
    static let kUser : String = "User";

    struct AppId {
        static let buglyAppId = "000b731ad0"

    }
    
    struct Keys {
        static let DDC_Device_SUITENAME = "group.com.daydaycook.com"
        static let DDC_Device_IDFA_Key = "IDFA"
        static let DDC_Device_UUID_Key = "OpenUUID"
    }
    
    lazy var user : DDCUserModel? = {
        var user = DDCUserModel()
        var userData : NSData = DDCUserDefaults.objectForKey(key: DDCStore.kUser) as! NSData
        if userData.length > 0
        {
            user = NSKeyedUnarchiver.unarchiveObject(with: userData as Data) as! DDCUserModel
        }
        return user
    }()
    
}
