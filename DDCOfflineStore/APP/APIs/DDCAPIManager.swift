//
//  DDCAPIManager.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/8.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import Alamofire

public var DDC_Current_Url = "https://offcourse.daydaycook.com.cn/daydaycook"

class DDCAPIManager: NSObject {
    
    //创建请求类枚举
    enum RequestType: Int {
        case requestTypeGet
        case requestTypePost
    }
    
    typealias sendVlesClosure = (AnyObject?, NSError?)->Void
    typealias uploadClosure = (AnyObject?, NSError?,Int64?,Int64?,Int64?)->Void
    
    /*
     * 配置你的网络环境
     */
    enum  NetworkEnvironment{
        case Release
        case Development
        case Test
        case Staging
    }
    
    // 登录服务
    private var DDC_Base_Url = "https://offcourse.daydaycook.com.cn/daydaycook"
    private var DDC_Base_Staging_Url = "https://offline-course-s.daydaycook.com.cn/daydaycook"
    private var DDC_Base_Test_Url = "https://offline-course-t.daydaycook.com.cn/daydaycook"
    private var DDC_Base_Dev_Url = "http://192.168.18.114:8088/daydaycook"

    let currentNetWork : NetworkEnvironment = .Test

    private func setUrlConfig(network : NetworkEnvironment) {
        
        switch network {
        case .Release:
            DDC_Base_Url = "https://offcourse.daydaycook.com.cn/daydaycook"
        case .Development:
            DDC_Base_Url = "http://192.168.18.114:8088/daydaycook"
        case .Test:
            DDC_Base_Url = "https://offline-course-t.daydaycook.com.cn/daydaycook"
        default:
            DDC_Base_Url = "https://offline-course-s.daydaycook.com.cn/daydaycook"
        }
    }
}

class DDCHttpSessionsRequest: NSObject {
    
    class func requestData(_ type : DDCAPIManager.RequestType, url : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> ()) {
        
        // 1.获取类型
        let method = (type == .requestTypeGet) ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
        Alamofire.request(url, method: method, parameters: parameters).responseJSON { (response) in
            
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            
            // 4.将结果回调出去
            finishedCallback(result)
        }
    }
}


