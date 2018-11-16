//
//  DDCPaymentOptionModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/16.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCPaymentOptionModel: DDCCheckBoxModel {
    var iconImageName: String?
    var desc: String?
    var price: String?

    // Mappable
    override func mapping(map: Map) {
        iconImageName <- map["iconImageName"]
        desc <- map["desc"]
        price <- map["price"]
        id <- map["id"]
        title <- map["name"]
    }
}
