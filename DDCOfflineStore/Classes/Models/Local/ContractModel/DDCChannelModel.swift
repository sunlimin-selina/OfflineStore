//
//  DDCChannelModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/19.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCChannelModel: Mappable {
    var id: Int?
    var name: String?
    var code: String?
    var descStatus: Bool?
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        descStatus <- map["descStatus"]
    }
    
}
