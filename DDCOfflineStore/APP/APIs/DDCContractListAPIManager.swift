//
//  DDCContractListAPIManager.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/8.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import Alamofire

class DDCContractListAPIManager: NSObject {
    class func downloadContractListForPage(page : UInt,status:UInt ,successHandler: @escaping (_ result : Any) -> (), failHandler: @escaping (_ result : Any) -> ()) {
        let url:String = DDC_Current_Url.appendingFormat("/server/contract/list.do")
        let uid:String = DDC_Current_Url.appendingFormat("/server/contract/list.do")

        let params : NSDictionary = ["uid":uid , "currentPage":page ,"status":status , "pageSize" : 10]
        
        DDCHttpSessionsRequest.requestData(.requestTypePost, url: url, parameters: (params as! [String : Any])) { (Any) in
            
        }
    }
}
