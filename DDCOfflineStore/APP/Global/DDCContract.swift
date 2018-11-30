//
//  DDCContract.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//
import Foundation

enum DDCContractStatus: UInt , Codable{
    case all
    case inComplete //未完成    -> 1:未支付
    case ineffective //未生效   -> 2:已经支付未开始预定
    case effective //生效中     -> 3:生效
    case completed //已结束     -> 4:过期
    case cancel //已取消        -> 新增 5:取消
    case used //已核销          -> 6:核销完
    case revoked //已解除       -> 7:解绑
}

enum DDCCustomerType: Int , Codable{
    case new //新用户
    case regular  //正式客户
    case potential //潜在客户
}

enum DDCContractType: UInt , Codable{
    case none
    case personalRegular //个人正式课
    case personalSample  //个人体验课
    case groupRegular  //团体正式课
    case groupSample  //团体体验课
}

enum DDCCourseType: Int , Codable {
    case sample  // 体验课程
    case regular // 正式课程
    case group  // 团体课程
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

class DDCContract: NSObject {

    static var backendStatusArray: Array<String> {
        get {
            return ["全部","未完成","未生效","生效中","已结束","已取消","已核销","已解除"]
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
            return [DDCContractStatus.ineffective.rawValue: DDCStatusViewModel.init(color: DDCColor.colorWithHex(RGB: 0xF7B761), title: "待生效", imageName: "icon_contractdetails_daishengxiao"),DDCContractStatus.used.rawValue: DDCStatusViewModel.init(color: DDCColor.colorWithHex(RGB: 0xC4C4C4), title: "已核销", imageName: "icon_contractdetails_yihexiao"),DDCContractStatus.inComplete.rawValue: DDCStatusViewModel.init(color: DDCColor.colorWithHex(RGB: 0xFF5269), title: "未完成", imageName: "icon_contractdetails_weiwancheng"),DDCContractStatus.effective.rawValue: DDCStatusViewModel.init(color: DDCColor.colorWithHex(RGB: 0x3AC09F), title: "生效中", imageName: "icon_contractdetails_shengxiaozhong"),DDCContractStatus.completed.rawValue: DDCStatusViewModel.init(color: DDCColor.colorWithHex(RGB: 0x474747), title: "已结束", imageName: "icon_contractdetails_yijieshu"),DDCContractStatus.revoked.rawValue: DDCStatusViewModel.init(color: DDCColor.colorWithHex(RGB: 0xC4C4C4), title: "已解除", imageName: "icon_contractdetails_yijiechu"),DDCContractStatus.cancel.rawValue: DDCStatusViewModel.init(color: DDCColor.colorWithHex(RGB: 0xC4C4C4), title: "已取消", imageName: "icon_contractdetails_yiquxiao")]
        }
    }

}
