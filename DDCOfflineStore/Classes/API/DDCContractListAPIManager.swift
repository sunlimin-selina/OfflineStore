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
    class func downloadContractListForPage() {
        let url:String = DDCStore.BaseUrl.DDC_CN_Url.appendingFormat("/server/contract/list.do")
        
        Alamofire.request(url).responseJSON {
            response in debugPrint(response)
            
            if let json = response.result.value {
                print("JSON: \(json)")
            }
        }
    }
}
