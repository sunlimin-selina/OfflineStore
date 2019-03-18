//
//  DDCUserModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCUserModel: NSObject, Mappable ,NSCoding {
    
    var id: Int?
    var userName: String?
    var name: String?
    var imageUrl: String?
    var recommendType: String?
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        id <- map["id"]
        userName <- map["userName"]
        name <- map["name"]
        imageUrl <- map["imageUrl"]
        recommendType <- map["recommendType"]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey:"id")
        aCoder.encode(userName, forKey:"userName")
        aCoder.encode(name, forKey:"name")
        aCoder.encode(imageUrl, forKey:"imageUrl")
        aCoder.encode(recommendType, forKey:"recommendType")
    }

    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? Int
        self.userName = aDecoder.decodeObject(forKey: "userName") as? String ?? ""
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as? String ?? ""
        self.recommendType = aDecoder.decodeObject(forKey: "recommendType") as? String ?? ""
    }

    
}
