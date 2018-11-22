//
//  DDCStoreModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCStoreModel: DDCCheckBoxModel {
    
    var shopId: Int?
    var shopName: String?
    
    override func mapping(map: Map) {
        id <- map["id"]
        title <- map["name"]
        shopId <- map["shopId"]
        shopName <- map["shopName"]
    }

}
