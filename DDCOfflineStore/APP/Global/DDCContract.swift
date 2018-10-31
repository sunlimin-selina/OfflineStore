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
    case effective //生效中
    case ineffective //未生效
    case inComplete //未完成
    case completed //已结束
    case revoked //已解除
    case used //已核销
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
    
    static var genderArray: Array<String> {
        get {
            return ["男","女"]
        }
    }
    
    static var occupationArray: Array<String> {
        get {
            return ["公司职员","家庭主妇", "自由职业者", "私营企业主", "企业高管", "学生", "其他"]
        }
    }

    static var statusPairings: Dictionary<UInt, DDCStatusViewModel> {
        get {
            return [DDCContractStatus.ineffective.rawValue : DDCStatusViewModel.init(color: DDCColor.colorWithHex(RGB: 0xFF9C27), title: "未生效", imageName: "icon_contractdetails_weishengxiao"),DDCContractStatus.used.rawValue : DDCStatusViewModel.init(color: DDCColor.colorWithHex(RGB: 0xF7B761), title: "已核销", imageName: "icon_contractdetails_yixiaohe"),DDCContractStatus.inComplete.rawValue : DDCStatusViewModel.init(color: DDCColor.colorWithHex(RGB: 0xFF5D31), title: "未完成", imageName: "icon_contractdetails_weiwancheng"),DDCContractStatus.effective.rawValue : DDCStatusViewModel.init(color: DDCColor.colorWithHex(RGB: 0x3AC09F), title: "生效中", imageName: "icon_contractdetails_shengxiaozhong"),DDCContractStatus.completed.rawValue : DDCStatusViewModel.init(color: DDCColor.colorWithHex(RGB: 0x474747), title: "已结束", imageName: "icon_contractdetails_yijieshu"),DDCContractStatus.revoked.rawValue : DDCStatusViewModel.init(color: DDCColor.colorWithHex(RGB: 0xC4C4C4), title: "已解除", imageName: "icon_contractdetails_yijiechu")]
        }
    }

}
