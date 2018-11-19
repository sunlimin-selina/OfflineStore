//
//  DDCCustomerModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCCustomerModel: Mappable {
    var id: Int?
    var mobile: String?
    var name: String?
    var age: String?
    var email: String?
    var sex: DDCGender?
    var birthday: Int?
    var career: DDCOccupation?
    var channelCode: String?
    var channelDesc: String?
    var type: DDCContractType?
    
    var introduceMobile: String?
    var introduceName: String?
    var dutyUserName: String?
    var dutyUserId: Int?

    var isReferral: Int?
    var formattedBirthday: String?

    init() {
    }
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        
        id <- map["id"]
        mobile <- map["mobile"]
        name <- map["name"]
        email <- map["email"]
        sex <- map["sex"]
        birthday <- map["birthday"]
        career <- map["career"]
        channelCode <- map["channelCode"]
        channelDesc <- map["channelDesc"]
        introduceMobile <- map["introduceMobile"]
        introduceName <- map["introduceName"]
        dutyUserId <- map["dutyUserId"]
        dutyUserName <- map["dutyUserName"]
        if let _birthday = birthday {
            self.formattedBirthday = DDCTools.date(from: _birthday)
        }
    }

}
