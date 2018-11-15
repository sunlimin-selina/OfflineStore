//
//  DDCEditClientInfoModelFactory.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation

class DDCEditClientInfoModelFactory: NSObject {
    class func integrateData(model: DDCCustomerModel, channels:[DDCChannelModel]?) -> [DDCContractInfoViewModel] {
        var array: [DDCContractInfoViewModel] = Array()
        //手机号码
        let phoneNumber: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "手机号码", placeholder: "请输入手机号码", text: model.userName ?? "", isRequired: true, tips: "创建后无法修改，请谨慎录入")
        //姓名
        let name: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "姓名", placeholder: "请输入姓名", text: model.nickName ?? "", isRequired: true, tips: "")
        //性别
        let sex: String = (model.sex != nil) ? DDCContract.genderArray[(model.sex!.rawValue)]: ""
        let gender: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "性别", placeholder: "请选择性别", text: sex, isRequired: true, tips: "")
        //生日
        let birthday: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "生日", placeholder: "请输入生日", text: model.formattedBirthday ?? "", isRequired: true,  tips: "")
        //年龄
        let age: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "年龄", placeholder: "年龄", text: model.age ?? "", isRequired: false, tips: "")
        //邮箱
        let email: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "邮箱", placeholder: "邮箱", text: model.email ?? "", isRequired: false, tips: "")
        //职业
        let careerText: String = model.career != nil ? DDCContract.occupationArray[Int(model.career!)!]: ""
        let career: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "职业", placeholder: "请选择职业", text: careerText, isRequired: false, tips: "")
        //渠道
        let channel: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "渠道", placeholder: "请选择渠道", text:"", isRequired: true, tips: "")
        //渠道详情
        let channelDetail: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "渠道详情", placeholder: "请录入详情", text:"", isRequired: true, tips: "")
        //是否会员介绍
        let memberReferral: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "是否会员介绍", placeholder: "请选择", text:"", isRequired: true, tips: "")
        
        //责任销售
        let responsibleUsername: String = (model.responsibleUsername != nil ? model.responsibleUsername: DDCStore.sharedStore().user?.name)!
        
        let sales: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "责任销售", placeholder: "责任销售", text:responsibleUsername, isRequired: false, tips: "")
        
        array = [phoneNumber, name, gender, birthday, age, email, career, channel, channelDetail, memberReferral, sales]
        
        return array
    }
    
    class func reloadData(models: [DDCContractInfoViewModel], isReferral: Bool) -> [DDCContractInfoViewModel] {
        var newModels = models

        if isReferral {
            if newModels.count < 12 {
                //介绍会员电话
                let memberPhone: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "介绍会员电话", placeholder: "请输入会员电话", text:"", isRequired: true, tips: "")
                //介绍会员姓名
                let memberName: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "介绍会员姓名", placeholder: "请输入会员电话后验证", text:"", isRequired: false, tips: "")
                
                newModels.insert(memberPhone, at: 10)
                newModels.insert(memberName, at: 11)
                return newModels
            }
        } else {
            if newModels.count > 12 {
                newModels.remove(at: 11)
                newModels.remove(at: 10)
            }
        }
        return newModels
    }
}
