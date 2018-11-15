//
//  DDCAddContractInfoModelFactory.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/12.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation

class DDCAddContractInfoModelFactory: NSObject {

    class func integrateData(model: DDCContractModel?, type: DDCCourseType) -> [DDCContractInfoViewModel] {
        
        switch type {
        case .group:
            return DDCAddContractInfoModelFactory.getGroupData(model)!
        case .regular, .sample :
            return DDCAddContractInfoModelFactory.getRegularOrSampleData(model: model,type: type)!
        default:
            return []
        }
        
    }
    
    class func getGroupData(_ model: DDCContractModel?) -> [DDCContractInfoViewModel]? {
        var array: [DDCContractInfoViewModel] = Array()
        //默认信息
        let defaultInfo: DDCContractInfoViewModel = DDCContractInfoViewModel()
        //合同编号
        let contractNumber: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "合同编号", placeholder: "请扫描合同编号", text: "", isRequired: true, tips: "")
        //产品规格-正式课
        let specification: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "产品规格", placeholder: "购买正式课程", text: "", isRequired: true, tips: "")
        //产品规格-体验课
        let sample: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "产品规格", placeholder: "购买体验课程", text: "", isRequired: true, tips: "")
        //课程进阶规则
        let orderRule: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "课程进阶规则", placeholder: "请选择课程进阶规则", text: "", isRequired: true,  tips: "")
        //合同金额
        let money: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "合同金额", placeholder: "请输入合同金额", text: "", isRequired: true, tips: "")
        //生效日期(今日生效)
        let startDate: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "生效日期", placeholder: "", text: "", isRequired: false, tips: "(今日生效)")
        //结束日期
        let endDate: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "结束日期", placeholder: "请选择职业", text: "", isRequired: false, tips: "")
        //有效时间(有效时间≦本月剩余天数+48个月)
        let effectiveTime: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "有效时间", placeholder: "", text:"", isRequired: false, tips: "(有效时间≦本月剩余天数+48个月)")
        //有效门店
        let store: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "有效门店", placeholder: "", text:"", isRequired: false, tips: "")
        
        array = [defaultInfo, contractNumber, specification, sample, orderRule, money, startDate, endDate, effectiveTime, store]
        return array

    }
    
    class func getRegularOrSampleData(model: DDCContractModel? , type: DDCCourseType) -> [DDCContractInfoViewModel]? {
        var array: [DDCContractInfoViewModel] = Array()
        //默认信息
        let defaultInfo: DDCContractInfoViewModel = DDCContractInfoViewModel()
        //合同编号
        let contractNumber: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "合同编号", placeholder: "请扫描合同编号", text: "", isRequired: true, tips: "")
        //产品套餐
        let title: String = (type == DDCCourseType.sample) ? "体验课课产品" : "正式课产品套餐"
        let package: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: title, placeholder: "请选择产品套餐", text: "", isRequired: true, tips: "")//体验课
        //产品规格
        let specification: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "产品规格", placeholder: "请选择产品规格", text: "", isRequired: true, tips: "")
        //课程进阶规则
        let orderRule: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "课程进阶规则", placeholder: "请选择课程进阶规则", text: "", isRequired: true,  tips: "")
        //合同金额
        let money: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "合同金额", placeholder: "请输入合同金额", text: "", isRequired: true, tips: "")
        //生效日期(今日生效)
        let startDate: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "生效日期", placeholder: "", text: "", isRequired: false, tips: "(今日生效)")
        //结束日期
        let endDate: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "结束日期", placeholder: "请选择职业", text: "", isRequired: false, tips: "")
        //有效时间(有效时间≦本月剩余天数+48个月)
        let effectiveTime: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "有效时间", placeholder: "", text:"", isRequired: false, tips: "(有效时间≦本月剩余天数+48个月)")
        //有效门店
        let store: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "有效门店", placeholder: "", text:"", isRequired: false, tips: "")
        
        array = [defaultInfo, contractNumber, package, specification, orderRule, money, startDate, endDate, effectiveTime, store]
        return array
    }
    
}
