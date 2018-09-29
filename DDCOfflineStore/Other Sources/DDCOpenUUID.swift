//
//  DDCOpenUUID.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation

class DDCOpenUUID : NSObject {
    struct identifier {
        var kOpenUUIDSessionCache : String?
        static let kUUIDInSerice = "app.daydaycook.uuid.service";
        static let kOpenUUIDDomain = "app.daydaycook.OpenUDID";
    }
    
    class func randomUUID () -> String {
        if (NSClassFromString("NSUUID") != nil) {
            return NSUUID().uuidString
        }
        let uuidRef : CFUUID = CFUUIDCreate(kCFAllocatorDefault)
        let cfuuid : CFString = CFUUIDCreateString(kCFAllocatorDefault, uuidRef)
        return cfuuid as String;
    }
    
    class func value () -> String{
        return DDCOpenUUID.valueWithError(error: nil)
    }
    
    class func valueWithError (error : NSError?) -> String{
//        if (kOpenUUIDSessionCache && kOpenUUIDSessionCache.length) {
//            if (error!=nil)
//            *error = [NSError errorWithDomain:kOpenUUIDDomain
//            code:kOpenUUIDErrorNone
//            userInfo:@{@"description": @"OpenUUID in cache from first call"}];
//            return kOpenUUIDSessionCache;
//        }
//
        return DDCOpenUUID.userDefault();
    }
    
    class func userDefault () -> String{
        var kOpenUUIDSessionCache = DDCUserDefaults.objectForKey(key: DDCStore.Keys.DDC_Device_UUID_Key)
//        if (!kOpenUUIDSessionCache || !kOpenUUIDSessionCache.length) {
//            kOpenUUIDSessionCache = [DDC_OpenUUID randomUUID];
//            [DDCUserDefaults setObject:kOpenUUIDSessionCache forKey:DDC_Device_UUID_Key];//kOpenUUID
//            DDC_Share_UUID = kOpenUUIDSessionCache;
//
//            [DDC_OpenUUID uploadDeviceInfoData];
//        }else if(![DDCUserDefaults objectForKey:kUUIDInSerice]) {
//            [DDC_OpenUUID uploadDeviceInfoData];
//        }
        return kOpenUUIDSessionCache as! String;
    }
    

}
