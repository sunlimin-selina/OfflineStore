//
//  DDCUserModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation

class DDCUserModel: NSObject {
    var ID : String?
    var userName : String?
    var name : String?
    var imageUrl : String?
    
    let kIdentifier : String = "id"
    let kUserName : String = "userName"
    let kName : String = "name"
    let kImageUrl : String = "imageUrl"

    init(dictionary : Dictionary<String, Any>) {
        print(dictionary)
        self.ID = (dictionary[kIdentifier] as? String) ?? ""
        self.userName = (dictionary[kUserName] as? String) ?? ""
        self.name = (dictionary[kName] as? String) ?? ""
        self.imageUrl = dictionary[kImageUrl] as? String
    }
}
