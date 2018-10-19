//
//  DDCStoreModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCStoreModel: Mappable {
    
    var id: Int?
    var title: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
    }
    
    class func model(with title: String, ID: String) -> DDCContractTypeModel {
        let model: DDCContractTypeModel = DDCContractTypeModel()
        model.ID = ID
        model.title = title
        return model
    }
    
}
