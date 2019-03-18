//
//  DDCOffLineStoreModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/18.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCOffLineStoreModel: Mappable {
    var id: Int?
    var name: String?
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
    
}
