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
        let upgradeLimit: String = (model?.packageModel?.upgradeLimit == 1) ? "遵守":"跳过"
        let orderRule: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "课程进阶规则", placeholder: "请选择课程进阶规则", text: "", isRequired: true,  tips: "")
        //合同金额
        let money: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "合同金额", placeholder: "请输入合同金额", text: "", isRequired: true, tips: "")
        //生效日期
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let startDate: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "生效日期", placeholder: dateFormatter.string(from: Date()), text: "", isRequired: false, tips: "")
        //结束日期
        let endDate: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "结束日期", placeholder: "根据课程购买数量自动计算得出", text: "", isRequired: false, tips: "")
        //有效时间(有效时间≦本月剩余天数+48个月)
        let effectiveTime: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "有效时间", placeholder: "根据课程购买数量自动计算得出", text:"", isRequired: false, tips: "(有效时间≦本月剩余天数+48个月)")
        //有效门店
        let store: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "有效门店", placeholder: DDCAddContractInfoModelFactory.getRelationShop(array: model?.relationShops), text: "", isRequired: false, tips: "")
        
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
        let upgradeLimit: String = (model?.packageModel?.upgradeLimit == 1) ? "遵守":"跳过"
        let orderRule: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "课程进阶规则", placeholder: "请选择课程进阶规则", text: upgradeLimit, isRequired: true,  tips: "")
        //合同金额
        let money: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "合同金额", placeholder: "请输入合同金额", text: "", isRequired: true, tips: "")
        //生效日期(今日生效)
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let startDate: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "生效日期", placeholder: dateFormatter.string(from: Date()), text: "", isRequired: false, tips: "(今日生效)")
        //结束日期
        let endDate: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "结束日期", placeholder: "根据课程购买数量自动计算得出", text: "", isRequired: false, tips: "")
        //有效时间(有效时间≦本月剩余天数+48个月)
        let effectiveTime: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "有效时间", placeholder: "根据课程购买数量自动计算得出", text:"", isRequired: false, tips: "(有效时间≦本月剩余天数+48个月)")
        //有效门店
        let store: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "有效门店", placeholder: DDCAddContractInfoModelFactory.getRelationShop(array: model?.relationShops), text: "", isRequired: false, tips: "")
        
        array = [defaultInfo, contractNumber, package, specification, orderRule, money, startDate, endDate, effectiveTime, store]
        return array
    }
    
    class func getRelationShop(array: [DDCStoreModel]?) -> String {
        var relationShop: String = ""
        if let shops = array {
            for idx in 0...(shops.count - 1) {
                let item = shops[idx]
                relationShop = relationShop + item.shopName!
                if idx != shops.count - 1 {
                    relationShop = relationShop + ","
                }
            }
        }
        return relationShop
    }
    
}

// MARK: Packing
extension DDCAddContractInfoModelFactory {
    class func packData(model: DDCContractModel) -> Dictionary<String, Any> {
        let dictionary: Dictionary<String, Any> = [ "beginEffectiveTime": model.packageModel?.startUseTime as Any,
                                                    "channel": "",
                                                    "code":model.code as Any,
                                                    "courseUseType": model.packageModel!.packageType as Any,
                                                    "createUserId": model.customer?.dutyUserId as Any,
                                                    "dealPrice":model.contractPrice as Any,
                                                    "dealShopId":model.currentStore?.id as Any,
                                                    "dealUserId":model.customer?.dutyUserId as Any,
                                                    "endEffectiveTime":model.packageModel?.endEffectiveTime as Any,
            "operateBizType":"COURSE",
            "operateUserId":model.customer?.dutyUserId as Any,
            "operateUserType":2,
            "packageId":model.packageModel?.id as Any,
            "paltform":1,
            "paperBeginTime":model.packageModel?.startUseTime as Any,
            "paperEndTime":model.packageModel?.endEffectiveTime as Any,
            "relationShops": model.relationShops as Any,//c转成数字z数组
            "useInfos": DDCAddContractInfoModelFactory.getUserInfos(model: model),
            "remark":"",
            "sourcePaltform":1,
            "type":1,//合同类型（1, "个人正式课合同" 2, "个人体验课合同" 3, "团体正式课合同" 4, "团体体验课合同"）
            "upgradeLimit":1,//－－进阶规则（0, "不限制" 1, "限制"）
            "userId":model.customer?.userid as Any,
            "virtualSkuId":model.packageCategoryModel?.id as Any
        ]
        return dictionary
    }
    
    class func getUserInfos(model: DDCContractModel) -> [Dictionary<String, Any>]{
        let dictionary: Dictionary<String, Any> = Dictionary()
        
        return [dictionary]
    }
}
