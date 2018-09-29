//
//  DDCStore.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation

class DDCStore : NSObject{
    struct AppId {
        static let buglyAppId = "000b731ad0"

    }
    
    struct Keys {
        static let DDC_Device_SUITENAME = "group.com.daydaycook.com"
        static let DDC_Device_IDFA_Key = "IDFA"
        static let DDC_Device_UUID_Key = "OpenUUID"
    }
    
}