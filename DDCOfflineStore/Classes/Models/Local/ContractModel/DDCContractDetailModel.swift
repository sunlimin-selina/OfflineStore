//
//  DDCContractDetailModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/20.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import ObjectMapper

class DDCContractDetailModel: Mappable {
    var code: String?
    var title: String?
    
    var salePrice: String?
    var beginEffectiveTime: String?
    var endEffectiveTime: String?
    
    var channelName: String?
    var dealShopName: String?
    var effectiveShopName: String?
    
    var createUserName: String?
    var dealUserName: String?
    var realUserName: String?
    
    var tradeStatus: String?
    var payStyle: String?
    var lineUserName: String?
    
    var sex: String?
    var birthday: String?
    var username: String?
    
    var lineUserCareer: String?
    var lineUserEmail: String?
    var introduceName: String?
    
    var introduceMobile: String?
    var skuName: String?
    var upgradeLimit: String?
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        title <- map["title"]

        salePrice <- map["salePrice"]
        beginEffectiveTime <- map["beginEffectiveTime"]
        endEffectiveTime <- map["endEffectiveTime"]
  
        channelName <- map["channelName"]
        dealShopName <- map["dealShopName"]
        effectiveShopName <- map["effectiveShopName"]
        
        createUserName <- map["createUserName"]
        dealUserName <- map["dealUserName"]
        realUserName <- map["realUserName"]
        
        tradeStatus <- map["tradeStatus"]
        payStyle <- map["payStyle"]
        lineUserName <- map["lineUserName"]
        
        sex <- map["sex"]
        birthday <- map["birthday"]
        username <- map["username"]
        
        lineUserCareer <- map["lineUserCareer"]
        lineUserEmail <- map["lineUserEmail"]
        introduceName <- map["introduceName"]
        
        introduceMobile <- map["introduceMobile"]
        skuName <- map["skuName"]
        upgradeLimit <- map["upgradeLimit"]
    }
 
}
