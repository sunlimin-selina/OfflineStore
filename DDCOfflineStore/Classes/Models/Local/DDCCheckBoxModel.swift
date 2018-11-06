//
//  DDCCheckBoxModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/5.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCCheckBoxModel: Mappable {
    
    var id: Int?
    var title: String?
    
    init(id: Int?, title: String?) {
        self.id = id
        self.title = title
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["name"]
    }
    
}
