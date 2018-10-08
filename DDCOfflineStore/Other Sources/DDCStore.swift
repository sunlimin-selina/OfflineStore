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
    
    struct AppId {
        static let buglyAppId = "000b731ad0"

    }
    
    struct screenSize {
        static let screenWidth = UIScreen.main.bounds.width
        static let screenHeight = UIScreen.main.bounds.height
    }
    
    struct Keys {
        static let DDC_Device_SUITENAME = "group.com.daydaycook.com"
        static let DDC_Device_IDFA_Key = "IDFA"
        static let DDC_Device_UUID_Key = "OpenUUID"
    }
    
    struct BaseUrl {
        static let DDC_CN_Url = "https://offcourse.daydaycook.com.cn/daydaycook"
        static let DDC_Base_Staging_Url = "https://offline-course-s.daydaycook.com.cn/daydaycook"
        static let DDC_Base_Test_Url = "https://offline-course-t.daydaycook.com.cn/daydaycook"
        static let DDC_Base_Dev_Url = "http://192.168.18.114:8088/daydaycook"
    }
}
