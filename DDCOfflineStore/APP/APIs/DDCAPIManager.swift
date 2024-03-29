//
//  DDCAPIManager.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/8.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import Alamofire

//public var DDC_Current_Url = "https://offcourse.daydaycook.com.cn/daydaycook"

class DDCAPIManager: NSObject {
    
    //创建请求类枚举
    enum RequestType: Int {
        case get
        case post
    }
    
    typealias sendVlesClosure = (AnyObject?, NSError?)->Void
    typealias uploadClosure = (AnyObject?, NSError?,Int64?,Int64?,Int64?)->Void
    
    /*
     * 配置你的网络环境
     */
    enum  NetworkEnvironment: Int{
        case Test
        case Development
        case Staging
        case Release
    }
    
    // 登录服务
    private var DDC_Base_Url = "https://offcourse.daydaycook.com.cn/daydaycook"
    private var DDC_Base_Staging_Url = "https://offline-course-s.daydaycook.com.cn/daydaycook"
    private var DDC_Base_Test_Url = "https://offline-course-t.daydaycook.com.cn/daydaycook"
    private var DDC_Base_Dev_Url = "http://192.168.129.90:8080/daydaycook"

    //更新地址
    static let DDC_Update_Url = "https://www.pgyer.com/VaQC"

    /// 当前环境
    private(set) var currentNetWork: NetworkEnvironment
    
    /// 根据环境获取请求地址
    fileprivate var baseUrl: String {
        get {
            switch self.currentNetWork {
            case .Release:
                return DDC_Base_Url
            case .Development:
                let ud = UserDefaults.standard
                let host = ud.string(forKey: "devHost")
                if let url = host {
                    return url
                }
                return DDC_Base_Dev_Url
            case .Test:
                return DDC_Base_Test_Url
            default:
                return DDC_Base_Staging_Url
            }
        }
    }
    
    /// 切换环境
    public func switchEnv(env: NetworkEnvironment) {
        self.currentNetWork = env
        let userDefault = UserDefaults.standard
        userDefault.set(env.rawValue, forKey: "env")
        userDefault.synchronize()
        DDC_Current_Url = DDCAPIManager.shared().baseUrl
    }
    
    private init(env: NetworkEnvironment) {
        self.currentNetWork = env
    }
    
    private static let sharedManager: DDCAPIManager = {
        #if Release
        let shared = DDCAPIManager(env: DDCAPIManager.NetworkEnvironment.Release)
        #else
        let userDefault = UserDefaults.standard
        let en = userDefault.integer(forKey: "env")
        let shared = DDCAPIManager(env: DDCAPIManager.NetworkEnvironment(rawValue: en) ?? DDCAPIManager.NetworkEnvironment.Test)
        #endif
        return shared
    }()
    
    /// 单例
    static func shared() -> DDCAPIManager {
        return sharedManager
    }
    
}

fileprivate(set) var DDC_Current_Url = DDCAPIManager.shared().baseUrl


/// 成功回调
typealias successClosure = (_ result: Dictionary<String, Any>?) -> ()

/// 失败回调
typealias failClosure = (_ errorInfo: String) -> ()


class DDCHttpSessionsRequest: NSObject {
    
    public static func callGetRequest(url: String, parameters: [String: Any]? = nil, success:@escaping successClosure, fail: @escaping failClosure) -> Void {
        
        callRequest(url: url, method: .get, parameters: parameters, success: success, fail: fail)
        
    }
    
    public static func callPostRequest(url: String, parameters: [String: Any]? = nil, success:@escaping successClosure, fail: @escaping failClosure) -> Void {
        
        callRequest(url: url, method: .post, parameters: parameters, success: success, fail: fail)
        
    }
    
    private static func callRequest(url: String, method: HTTPMethod, parameters: [String: Any]? = nil, success:@escaping successClosure, fail: @escaping failClosure) -> Void {
        
        var encoding: ParameterEncoding = URLEncoding.default
        
        if method == .post {
            encoding = JSONEncoding.default
        }
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding).responseJSON { (response) in
            
            if response.result.isSuccess {
                if let data = response.value {
                    let result = data as? Dictionary<String, Any> ?? [:]
                    success(result)
                } else {
                    assertionFailure("request sucess, but response return nil")
                    success(nil)
                }
            } else {
                var responseInfo = String(data: response.data!, encoding: String.Encoding.utf8) ?? "Empty Response String!!!"
                if let error = response.error {
                    responseInfo = url + "\n " + responseInfo + "\n " + error.localizedDescription
                }
                fail(responseInfo)
            }
        }
        
    }
    
    /// 拆分服务端返回的数据
    ///
    /// - Parameter response: 服务端返回的数据
    /// - Returns: 拆分后的数据，返回一个tuple，第一个是业务码，第二个是data数据可转化为Model，第三个是错误信息
    static func filterResponseServerData<T>(_ type: T.Type, response: Dictionary<String, Any>?) -> (code: Int, model: T?, message: String) where T: Codable {
        var result: (code: Int, model: T?, message: String)
        if let res = response {
            //获取业务码
            var code = -10000
            
            if res["code"] is Int {
                code = res["code"] as! Int
            } else if res["code"] is String {
                code = Int(res["code"] as! String)!
            }
            
            //获取数据字典
            let dictData = (res["data"] as? Dictionary<String, Any>)

            //dict -> data
            var model: T? = nil
            var data: Data? = nil
            if let dict = dictData {
                data = try? JSONSerialization.data(withJSONObject: dict, options: [])
            }
            //data -> model
            if let d = data {
                model = try? JSONDecoder().decode(type, from: d)
            }
            
            let message = (res["msg"] as? String) ?? ""
            result = (code, model, message)
        } else {
            result = (-10000, nil, "服务端返回数据为空")
        }
        print("{code:" + String(result.code) + ", msg:" + String(result.message) + "}")
        return result
    }
    
    static func filterResponseData(response: Dictionary<String, Any>?) -> (code: Int, data: AnyObject? , message: String){
        var result: (code: Int, data: AnyObject?, message: String)
        if let res = response {
            //获取业务码
            var code = -10000
            
            if res["code"] is Int {
                code = res["code"] as! Int
            } else if res["code"] is String {
                code = Int(res["code"] as! String)!
            }
            
            //获取数据字典
            let dictData = res["data"]
            
            let message = (res["msg"] as? String) ?? ""
            result = (code, dictData as AnyObject, message)
        } else {
            result = (-10000, nil, "服务端返回数据为空")
        }
        print("{code:" + String(result.code) + ", msg:" + String(result.message) + "}")
        return result
    }
}


