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
    //团体课程
    class func getGroupData(_ model: DDCContractModel?) -> [DDCContractInfoViewModel]? {
        var array: [DDCContractInfoViewModel] = Array()
        //默认信息
        let defaultInfo: DDCContractInfoViewModel = DDCContractInfoViewModel()
        //合同编号
        let contractNumber: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "合同编号", placeholder: model?.code ?? "请扫描合同编号", text: "", isRequired: true, tips: "")
        //产品规格-正式课
        let specification: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "产品规格", placeholder: "购买正式课程", text: "", isRequired: true, tips: "")
        specification.isFill = true
        //产品规格-体验课
        let sample: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "产品规格", placeholder: "购买体验课程", text: "", isRequired: false, tips: "")

        array = [defaultInfo, contractNumber, specification, sample]
        return DDCAddContractInfoModelFactory.appendLatterPart(model: model, array: array)
    }
    
    //正式和体验课程
    class func getRegularOrSampleData(model: DDCContractModel? , type: DDCCourseType) -> [DDCContractInfoViewModel]? {
        var array: [DDCContractInfoViewModel] = Array()
        //默认信息
        let defaultInfo: DDCContractInfoViewModel = DDCContractInfoViewModel()
        //合同编号
        let contractNumber: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "合同编号", placeholder: model?.code ?? "请扫描合同编号", text: "", isRequired: true, tips: "")
        //产品套餐
        let title: String = (type == DDCCourseType.sample) ? "体验课产品" : "正式课产品套餐"
        let package: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: title, placeholder: "请选择产品套餐", text: model?.packageModel?.name ?? "", isRequired: true, tips: "")
        package.isFill = model?.packageModel?.name != nil ? true : false
        //产品规格
        let spec = model?.specs?.name ?? ""
        let specification: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "产品规格", placeholder: "请选择产品规格", text: spec, isRequired: true, tips: "")
        specification.isFill = model?.specs?.name != nil ? true : false
        
        array = [defaultInfo, contractNumber, package, specification]
        return DDCAddContractInfoModelFactory.appendLatterPart(model: model, array: array)
    }
    
    //相同部分的model加载
    class func appendLatterPart(model: DDCContractModel? , array: [DDCContractInfoViewModel]) -> [DDCContractInfoViewModel]?  {
        let mutableArray: NSMutableArray = NSMutableArray.init(array: array)
        //课程进阶规则
        var upgradeLimit: String = (model?.packageModel?.upgradeLimit == 1) ? "遵守":"跳过"
        if model?.contractType == .groupRegular || model?.contractType == .groupSample {
            upgradeLimit = ""
        }
        let orderRule: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "课程进阶规则", placeholder: (model?.contractType == .groupRegular || model?.contractType == .groupSample) ? "跳过":"请选择课程进阶规则", text: upgradeLimit, isRequired: true,  tips: "")
        //合同金额
        let money = (model?.contractPrice != nil ? "\(model?.contractPrice ?? 0)" : ((model?.specs?.costPrice) != nil) ? "\(model?.specs?.costPrice ?? 0)" : "")
        let costPrice: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "合同金额", placeholder: "请输入合同金额", text: money, isRequired: true, tips: "")
        costPrice.isFill = model?.specs?.costPrice != nil ? true : false
        //生效日期(今日生效)
        let startTime: CLong = model?.packageModel?.startUseTime != nil ? (model?.packageModel?.startUseTime)! : DDCTools.dateToTimeInterval(from: Date())        
        let startDate: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "生效日期", placeholder: DDCTools.date(from: startTime), text: "", isRequired: false, tips: "(今日生效)")
        //有效时间(有效时间≦本月剩余天数+48个月)
        var validPeriod: Int = 0
        if model?.specs != nil ,
            let _validPeriod = model?.specs!.validPeriod {
            validPeriod = _validPeriod <= 48 ? _validPeriod : 48
        }
        let effectiveTime: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "有效时间", placeholder: validPeriod == 0 ? "根据课程购买数量自动计算得出" : "\(validPeriod)个月", text: "", isRequired: false, tips: "(有效时间≦本月剩余天数+48个月)")
        //结束日期
        let endDate: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "结束日期", placeholder: model?.packageModel?.endEffectiveTime != nil ? DDCTools.date(from: (model?.packageModel?.endEffectiveTime)!) : "根据课程购买数量自动计算得出", text: "", isRequired: false, tips: "")
        //有效门店
        let store: DDCContractInfoViewModel = DDCContractInfoViewModel.init(title: "有效门店", placeholder: DDCAddContractInfoModelFactory.getRelationShop(array: model?.relationShops), text: "", isRequired: false, tips: "")
        let arr = [orderRule, costPrice, startDate, endDate, effectiveTime, store]
        mutableArray.addObjects(from: arr)
        return (mutableArray.copy() as! [DDCContractInfoViewModel])
    }
    
    class func getRelationShop(array: [DDCStoreModel]?) -> String {
        var relationShop: String = ""
        if let shops = array {
            for idx in 0..<shops.count {
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
                                                    "courseUseType": model.packageModel!.packageType?.rawValue as Any,
                                                    "createUserId": (model.customer?.dutyUserId != nil && model.customer?.dutyUserId != 0) ? model.customer?.dutyUserId  as Any : DDCStore.sharedStore().user?.id as Any,
                                                    "dealPrice": (model.contractPrice != nil) ? Int(model.contractPrice! * 100) : Int((model.specs?.costPrice)! * 100) as Any,
                                                    "dealShopId":model.currentStore?.id as Any,
                                                    "dealUserId":(model.customer?.dutyUserId != nil && model.customer?.dutyUserId != 0) ? model.customer?.dutyUserId  as Any : DDCStore.sharedStore().user?.id as Any,
                                                    "endEffectiveTime": model.packageModel?.endEffectiveTime as Any,
            "operateBizType":"COURSE",
            "operateUserId":(model.customer?.dutyUserId != nil && model.customer?.dutyUserId != 0) ? model.customer?.dutyUserId  as Any : DDCStore.sharedStore().user?.id as Any,
            "operateUserType":2,
            "packageId":model.packageModel?.id as Any,
            "paltform":1,
            "paperBeginTime":model.packageModel?.startUseTime as Any,
            "paperEndTime": model.packageModel?.endEffectiveTime as Any,
            "relationShops": DDCAddContractInfoModelFactory.getRelationShops(shops: model.relationShops!) as Any,
            "useInfos": DDCAddContractInfoModelFactory.getUserInfos(model: model),
            "remark":"",
            "sourcePaltform":1,
            "type": (model.contractType?.rawValue)!,//合同类型（1, "个人正式课合同" 2, "个人体验课合同" 3, "团体正式课合同" 4, "团体体验课合同"）
            "upgradeLimit":model.packageModel?.upgradeLimit as Any,//－－进阶规则（0, "不限制" 1, "限制"）
            "userId":model.customer?.userId as Any,
            "virtualSkuId":model.specs?.id as Any
        ]
        return dictionary
    }
    
    class func getUserInfos(model: DDCContractModel) -> [Dictionary<String, Any>]{
        var dictionary: Dictionary<String, Any> = Dictionary()
        var array: [Dictionary<String, Any>] = Array()
        if let customs = model.customItems {
            for item in customs {
                if let _attributes = item.attributes {
                    for attribute in _attributes {
                        let validPeriod = attribute.totalCount //<= 48 ? attribute.totalCount : 48
                        dictionary = ["categoryId": attribute.categoryId as Any, "contractNo": model.code as Any, "courseMasterId": item.courseid as Any, "difficulty": attribute.attributeValueId as Any,  "validPeriod": model.packageModel?.endEffectiveTime as Any, "totalCount": validPeriod as Any, "useCount": validPeriod as Any]
                        array.append(dictionary)
                    }
                } else {
                    let validPeriod = item.totalCount //<= 48 ? item.totalCount : 48
                    dictionary = ["categoryId": item.courseid as Any, "contractNo": model.code as Any, "courseMasterId": item.courseid as Any, "difficulty": -1,  "validPeriod": model.packageModel?.endEffectiveTime as Any, "totalCount": validPeriod as Any, "useCount": validPeriod as Any]
                    array.append(dictionary)
                }
            }
        }
        return array
    }
    
    class func getStartDate(datetime: Int?) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        if datetime == nil {
            return dateFormatter.string(from: Date())
        }
        let date = DDCTools.datetime(from: datetime)
        var startDate: Date = Date()
        if date.compare(Date()) == .orderedDescending {
            startDate = date
        }
        return dateFormatter.string(from: startDate)
    }
    
    class func getRelationShops(shops: [DDCStoreModel]) -> [Int]{
        var shopIds: [Int] = Array()
        for item in shops {
            shopIds.append(item.shopId!)
        }
        return shopIds
    }
}
