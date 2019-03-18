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
    
    var id: CLong?
    var title: String?
    var discription: String?
    var isSelected: Bool = false
    
    init(id: Int?, title: String?, isSelected: Bool?) {
        self.id = id
        self.title = title
        self.isSelected = isSelected!
    }
    
    init(id: Int?, title: String?, discription: String, isSelected: Bool?) {
        self.id = id
        self.title = title
        self.discription = discription
        self.isSelected = isSelected!
    }
    
    init() {
    }

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["name"]
    }
}
