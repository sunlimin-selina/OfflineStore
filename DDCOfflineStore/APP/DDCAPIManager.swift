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
    // --文件上传
//    func DDCUpload(url:String,fileURL:NSURL,progress:(_ bytesWritten: Int64?,_ totalBytesWritten: Int64?,_ totalBytesExpectedToWrite: Int64?) -> Void, responseResult:(_ responseValue: AnyObject?,_ error: NSError?) -> Void) {
//
//        Alamofire.upload(fileURL, to: url, method: .POST, headers: nil)
//        Alamofire.upload(url,.POST, file: fileURL).progress {(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) -> Void in
//            progress(bytesWritten:bytesWritten,totalBytesWritten:totalBytesWritten,totalBytesExpectedToWrite:totalBytesExpectedToWrite)
//            }.responseJSON { response in
//                responseResult(responseValue:response.result.value,error:response.result.error)
//        }
    /*
     ** 写法二  block定义成宏的写法
     //fileURL实例:let fileURL = NSBundle.mainBundle().URLForResource("Default",withExtension: "png")
     func BLUpload(URLString:String,fileURL:NSURL,block:uploadClosure) {
     
     Alamofire.upload(.POST, URLString, file: fileURL).progress {(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) -> Void in
     block(nil,nil,bytesWritten ,totalBytesWritten,totalBytesExpectedToWrite)
     }.responseJSON { response in
     block(response.result.value,response.result.error,nil,nil,nil)
     }
     }
     
     
     */
    
    // --文件下载
    //下载到默认路径let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
//    let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
//    //默认路径可以设置为空,因为有默认路径
//    func BLDownload(type:RequestType,URLString:String,progress:(bytesRead: Int64?,totalBytesRead: Int64?,totalBytesExpectedToRead: Int64?) -> Void, responseResult:(responseValue: AnyObject?,error: NSError?) -> Void) {
//        switch type {
//        case .requestTypeGet:
//            Alamofire.download(.GET, URLString, destination: destination)
//                .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
//                    progress(bytesRead:bytesRead,totalBytesRead:totalBytesRead,totalBytesExpectedToRead:totalBytesExpectedToRead)
//                }
//                .response { (request, response, _, error) in
//                    responseResult(responseValue:response,error:error)
//            }
//            break
//        case .requestTypePost:
//            Alamofire.download(.POST, URLString, destination: destination)
//                .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
//                    progress(bytesRead:bytesRead,totalBytesRead:totalBytesRead,totalBytesExpectedToRead:totalBytesExpectedToRead)
//                }
//                .response { (request, response, _, error) in
//                    responseResult(responseValue:response,error:error)
//            }
//        }
//    }
    
    /* block定义成宏的写法
     
     let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
     //默认路径可以设置为空,因为有默认路径
     func BLDownload(type:RequestType,URLString:String,block:uploadClosure) {
     switch type {
     case .requestTypeGet:
     Alamofire.download(.GET, URLString, destination: destination)
     .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
     
     block(nil,nil,bytesRead, totalBytesRead, totalBytesExpectedToRead)
     }
     .response { (request, response, _, error) in
     block(response,error,nil,nil,nil)
     }
     break
     case .requestTypePost:
     Alamofire.download(.POST, URLString, destination: destination)
     .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
     block(nil,nil,bytesRead, totalBytesRead, totalBytesExpectedToRead)
     }
     .response { (request, response, _, error) in
     block(response,error,nil,nil,nil)
     }
     }
     }
     
     */
    
    // --上传多张图片
//    func BLPostUploadMultiPicture(url: String, parameters: AnyObject, imgParameters: [UIImage]?, successed:(responseObject: AnyObject?) -> (), failed: (error: NSError?) -> ()) {
//        Alamofire.upload(.POST, url, headers: parameters as? [String : String], multipartFormData: { (formData) in
//            for index in 0..<imgParameters!.count {
//
//                let imageData = UIImagePNGRepresentation(imgParameters![index] )
//                formData.appendBodyPart(data: imageData!, name: "img/(index)", fileName: "/(index).jpg", mimeType: "image/png")
//            }
//        }, encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold){ (result) in
//            switch result {
//            case .Success(let upload, _, _):
//                upload.responseJSON{ respone in
//                    print(respone.data)
//                    successed(responseObject: respone.data)
//
//                }
//            case .Failure(let error):
//
//                print(error)
//
//                break
//            }
//        }
//    }
    


