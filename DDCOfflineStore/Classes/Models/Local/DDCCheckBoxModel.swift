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
    var isSelected: Bool?
    
    init(id: Int?, title: String?, isSelected: Bool?) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
    }

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["name"]
    }
    
    class func  modelTransformation(models: [DDCStoreModel]?) -> [DDCCheckBoxModel] {
        var array: [DDCCheckBoxModel] = []
        
        if let stores = models,
            models!.count > 0{
            for store in stores {
                let model: DDCCheckBoxModel = DDCCheckBoxModel.init(id: store.id, title: store.title, isSelected: false)
                array.append(model)
            }
        }
        return array
    }
}