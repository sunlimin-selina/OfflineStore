//
//  DDCAppDelegate.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import Bugly
import AdSupport
import SnapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Bugly注册
//        Bugly.start(withAppId: "000b731ad0")
//        
//        let idfa : String = ASIdentifierManager.shared().advertisingIdentifier.uuidString
//        DDCUserDefaults.setObject(object: idfa as AnyObject, key: DDCStore.Keys.DDC_Device_IDFA_Key)
//        DDC_Share_UUID = DDCOpenUUID.value()
        
        // start collecting dates from server
//        [DDCServerDate sharedInstance]
        
        //初始化主窗口
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController.init(rootViewController: DDCContractListViewController())
        window?.rootViewController = navigationController
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        return true
    }

}

