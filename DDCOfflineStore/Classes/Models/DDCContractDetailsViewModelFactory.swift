//
//  DDCContractDetailsViewModel.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/23.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import UIKit

class DDCContractDetailsViewModel: NSObject {
    var title: String?
    var describe: String?
    var color: UIColor?

    init(title: String?, describe: String?) {
        super.init()
        self.title = title
        self.describe = describe
        self.color = DDCColor.fontColor.black
    }
    
    init(title: String?, describe: String?, color: UIColor?) {
        super.init()
        self.title = title
        self.describe = describe
        self.color = color
    }
}

class DDCContractDetailsViewModelFactory: NSObject {
    
    class func integrateData(model: DDCContractDetailModel) -> [DDCContractDetailsViewModel] {
        var array: [DDCContractDetailsViewModel] = Array()
        
        //订单编号
        let code: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "订单编号", describe: model.code)
        //订单状态
        let modelStatus: UInt = model.tradeStatus!.rawValue
        let statusModel: DDCStatusViewModel = DDCContract.statusPairings[modelStatus]!
        let status: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "订单状态", describe: ((model.tradeStatus != .all) ? statusModel.title: ""), color: statusModel.color)
        //姓名
        let name: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "姓名", describe: model.lineUserName)
        //性别
        let gender: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "性别", describe: model.sex)
        //年龄
        let birthdayD = DDCTools.datetime(from: model.birthday)
        let components = Calendar.current.dateComponents([.year], from: birthdayD, to: Date())
        let age: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "年龄", describe: (components.year != nil) ? "\(components.year!)岁": "")
        //生日
        let birthday: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "生日", describe: DDCTools.date(from: model.birthday!))
        //手机号码
        let phoneNumber: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "手机号码", describe: model.username)
        //职业
        let career: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "职业", describe: model.lineUserCareer)
        //邮箱
        let email: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "邮箱", describe: model.lineUserEmail)
        //顾客渠道
        let channel: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "顾客渠道", describe: model.channelName)
        //介绍会员
        let recommendUser: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "介绍会员", describe: (model.introduceMobile == nil || (model.introduceMobile?.count)! <= 0) ? "无" :  "\(model.introduceName ?? "") \(model.introduceMobile ?? "")" )
        //产品套餐
        let package: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "产品套餐", describe: model.title)
        //产品规格
        let course: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "产品规格", describe: model.skuName)
        //进阶规则
        let upgradeLimit: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "进阶规则", describe: model.upgradeLimit)
        //生效期限
        let effectiveTerm = (model.beginEffectiveTime != nil && model.endEffectiveTime != nil) ? "\(DDCTools.date(from: model.beginEffectiveTime!)) -\(DDCTools.date(from: model.endEffectiveTime!))" : ""
        let term: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "生效期限", describe: effectiveTerm)
        //有效时间
        let effectiveTime: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "有效时间", describe: model.validPeriod ?? "")
        //有效门店
        let store: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "有效门店", describe: model.effectiveShopName)
        //支付方式
        let payMethod: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "支付方式", describe: model.payStyle)
        //当前门店
        let currentStore: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "当前门店", describe: model.dealShopName)
        //支付金额
        let price: String = model.salePrice != nil ? "¥\(Double(model.salePrice!) / 100)" : ""
        let contractPrice: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "支付金额", describe:price)
        //签单员工
        let signedUsername: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "签单员工", describe: model.dealUserName)
        //责任销售
        let responsibleUsername: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "责任销售", describe: model.dealUserName)
        //业绩归属
        let createdUsername: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "业绩归属", describe: model.realUserName)
        array = [code, status, name, gender, age, birthday, phoneNumber, career, email, channel, recommendUser, package, course, upgradeLimit, term, effectiveTime, store, payMethod, contractPrice, currentStore, signedUsername, responsibleUsername, createdUsername]
        return array
    }
    
    class func integrateUserData(model: DDCContractModel) -> [DDCContractDetailsViewModel] {
        var array: [DDCContractDetailsViewModel] = Array()
        
        //当前客户
        let customer: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "当前客户", describe: model.customer?.name)
        //客户手机
        let phone: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "客户手机", describe: model.customer?.mobile)
        //客户类型
        let type: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "客户类型", describe: model.customer?.type?.rawValue == 1 ? "正式客户" : "潜在客户")
        //进行订单
        let order: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "进行订单", describe: "\(model.contractUseCount ?? 0)")
        //全部订单
        let allOrder: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "全部订单", describe: "\(model.contractAllCount ?? 0)")
        //约课次数
        let times: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "约课次数", describe: "\(model.reservationCount ?? 0) (3个月内)")
        //最后课程
        let finishCourse: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "最后课程", describe: model.lastCourseName)
       
        array = [customer, phone, type, order, allOrder, times, finishCourse]
        return array
    }
    
    class func integrateContractData(model: DDCContractModel?) -> [DDCContractDetailsViewModel] {
        var array: [DDCContractDetailsViewModel] = Array()
        
        //当前客户
        let customer: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "当前客户", describe: model?.customer?.mobile)
        //客户手机
        let phone: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "客户手机", describe: model?.customer?.name)
        //当前门店
        let store: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "当前门店", describe: model?.currentStore?.title)
        //销售类型
        var courseType: String = "新建体验课订单"
        if model?.courseType == .regular {
            courseType = "新建正式课电子合同"
        } else if model?.courseType == .group{
            courseType = "新建团体课电子合同"
        }
        let contractType: DDCContractDetailsViewModel = DDCContractDetailsViewModel.init(title: "销售类型", describe: courseType)
        
        array = [customer, phone, store, contractType]
        return array
    }
 
    class func channelViewModel(category: Categorys) -> DDCContractDetailsViewModel{
        if let array = category.channels{
            let channels: NSArray = array as NSArray
            
            if let channelId = category.model?.customer?.channelCode{
                let idx: Int = channels.indexOfObject { (channelModel, idx, stop) -> Bool in
                    if let object = channelModel as? DDCChannelModel{
                        return object.id == Int(channelId)
                    }
                    return false
                }
                if idx < channels.count,
                    let channel: DDCChannelModel = (channels[idx] as! DDCChannelModel) {
                    var string = category.model?.customer?.channelDesc
                    if string != nil,
                        (string!.count) > 0 {
                        string = "\(channel.name ?? "")-\(category.model!.customer!.channelDesc!)"
                    } else {
                        string = channel.name ?? ""
                    }
                    return DDCContractDetailsViewModel.init(title: "顾客渠道", describe:channel != nil ? string: "")
                }
            }
        }
        return DDCContractDetailsViewModel.init(title: "顾客渠道", describe:"")
    }
    
    class func convertModel(model: DDCContractDetailModel) -> DDCContractModel {
        let customer: DDCCustomerModel = DDCCustomerModel()
        let contractModel = DDCContractModel()
        customer.mobile = model.username
        customer.name = model.lineUserName
        //性别
        let genderArray: NSArray = DDCContract.genderArray as NSArray
        customer.sex = DDCGender(rawValue: genderArray.index(of: model.sex as Any))
        //生日
        customer.birthday = model.birthday
        //邮箱
        customer.email = model.lineUserEmail
        //职业
        let occupationArray: NSArray = DDCContract.occupationArray as NSArray
        customer.career = DDCOccupation(rawValue: occupationArray.index(of: model.lineUserCareer as Any))
        //是否会员介绍
        customer.isReferral = model.introduceMobile != nil ? true : false
        //会员手机号
        customer.introduceMobile = model.introduceMobile
        //会员姓名
        customer.introduceName = model.introduceName
        //责任销售
        customer.dutyUserName = model.dealUserName
        
        let package: DDCContractPackageModel = DDCContractPackageModel()
        package.upgradeLimit = Int(model.upgradeLimit!)
        package.title = model.title
        package.startUseTime = model.beginEffectiveTime
        package.endEffectiveTime = model.endEffectiveTime
        
        contractModel.customer = customer
        contractModel.packageModel = package
        
        contractModel.contractPrice = model.salePrice
        contractModel.code = model.code
        contractModel.id = model.contractId
        contractModel.currentStore?.title = model.dealShopName
        contractModel.createdUsername = model.createUserName
        contractModel.status = model.tradeStatus

        return contractModel
    }
}
