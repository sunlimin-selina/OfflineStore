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
    var id : Int?
    var userName : String?
    var nickName : String?
    var age : String?
    var email : String?
    var sex : DDCGender?
    var birthday : Int?
    var career : String?
    var channel : String?
    
    var formattedBirthday: String?
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        
        id <- map["id"]
        userName <- map["userName"]
        nickName <- map["lineUserName"]
        age <- map["age"]
        email <- map["lineUserEmail"]
        sex <- map["sex"]
        birthday <- map["birthday"]
        career <- map["lineUserCareer"]
        channel <- map["channel"]
        
        if let _birthday = birthday {
            self.formattedBirthday = DDCTools.date(from: _birthday)
        }
    }

}
