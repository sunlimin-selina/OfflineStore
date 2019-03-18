//
//  DDCPaymentOptionModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/16.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCPaymentItemModel: DDCCheckBoxModel {
    var code: String?
    
    // Mappable
    override func mapping(map: Map) {
        title <- map["name"]
        code <- map["code"]
    }
}

class DDCPaymentOptionModel: DDCCheckBoxModel {
    var iconImageName: String?
    var name: String?
    var price: String?
    var code: String?
    var channels: [DDCPaymentItemModel]?
    
    // Mappable
    override func mapping(map: Map) {
        iconImageName <- map["iconImageName"]
        price <- map["price"]
        id <- map["id"]
        title <- map["name"]
        code <- map["code"]
        channels <- map["channels"]
    }
}
