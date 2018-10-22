//
//  DDCContract.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//
import Foundation

enum DDCContractStatus : UInt , Codable{
    case all
    case effective//生效中
    case ineffective//未生效
    case inComplete//未完成
    case completed//已结束
    case revoked//已解除
    case used//已核销
}

enum DDCCourseType {
    case none
    case regular // 正式课程
    case sample  // 体验课程
}

enum DDCContractState {
    case done
    case doing
    case todo
}

enum DDCRegularCoursePurchaseType {
    case none
    case category
    case numberOfCourse
    case timeRestriction
}

class DDCContract : NSObject {
    static var displayStatusArray: Array<String> {
        get {
            return ["全部","生效中","未完成","已核销","已结束","已解除"]
        }
    }
    
    static var backendStatusArray: Array<String> {
        get {
            return ["全部","生效中","未生效","未完成","已核销","已结束","已解除"]
        }
    }
    
    static var payMethodArray: Array<String> {
        get {
            return ["","支付宝支付","微信支付","线下支付"]
        }
    }
}
