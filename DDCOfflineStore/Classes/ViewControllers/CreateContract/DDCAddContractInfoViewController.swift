//
//  DDCAddContractInfoViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader

class DDCAddContractInfoViewController: DDCContractInfoViewController {
    
    var customItems: [DDCCourseModel] = Array()
    
    var isPickedCustom: Bool = false
    var checkBoxFilled: Bool = false
    var modifySkuPrice: Bool = false
    var isCodeFilled: Bool {
        get {
            return (self.model?.courseType == .sample) ? true : self.model?.code != nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //刷新列表
        self.model?.packageModel = nil
        self.model?.specs = nil
        self.model?.contractPrice = nil
        self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
        self.contractInfo = DDCContractDetailsViewModelFactory.integrateContractData(model: self.model)
        self.collectionView.reloadData()
        //请求店铺套餐数据
        self.getPackagesForContract()
        //请求关联店铺
        self.getRelationShopOptions()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
    }
}

// MARK: Private
extension DDCAddContractInfoViewController {
    func setupCollectionView(){
        //注册cell和headerFooterView
        self.collectionView.register(DDCContractDetailsCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DDCContractDetailsCollectionViewCell.self))
        self.collectionView.register(DDCTitleTextFieldCell.self, forCellWithReuseIdentifier: String(describing: DDCTitleTextFieldCell.self))
        self.collectionView.register(DDCTextFieldButtonCell.self, forCellWithReuseIdentifier: String(describing: DDCTextFieldButtonCell.self))
        self.collectionView.register(DDCCheckBoxCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DDCCheckBoxCollectionViewCell.self))
        self.collectionView.register(DDCContractHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: DDCContractHeaderFooterView.self))
        self.collectionView.register(DDCSectionHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCSectionHeaderFooterView.self))
        self.collectionView.register(DDCRadioHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCRadioHeaderView.self))
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: UICollectionReusableView.self))
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
}

// MARK: UICollectionViewDelegate
extension DDCAddContractInfoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.contractInfo.count
        } else if self.isPickedCustom && section == 3 {
            return self.customItems.count
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCContractDetailsCollectionViewCell.self), for: indexPath) as! DDCContractDetailsCollectionViewCell
            let model = self.contractInfo[indexPath.item]
            cell.titleLabel.text = model.title
            cell.subtitleLabel.text = model.describe
            cell.titleLabel.textAlignment = .left
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCTextFieldButtonCell.self), for: indexPath) as! DDCTextFieldButtonCell
            let model: DDCContractInfoViewModel = self.models[indexPath.section]
            cell.configureCell(model: model, indexPath: indexPath, showHint: false)
            self.configureInputView(textField: cell.textFieldView.textField, indexPath: indexPath)
            cell.textFieldView.textField.tag = indexPath.section
            cell.textFieldView.textField.delegate = self
            cell.button.addTarget(self, action: #selector(scanAction(_:)), for: .touchUpInside)
            if self.model!.code != nil {
                cell.button.isSelected = true
            }
            cell.isHidden = false
            if self.model!.contractType == .personalSample {
                cell.isHidden = true
            }
            return cell
        }  else if self.isPickedCustom && indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCCheckBoxCollectionViewCell.self), for: indexPath) as! DDCCheckBoxCollectionViewCell
            cell.tag = indexPath.item
            let model: DDCCourseModel = self.customItems[indexPath.item]
            let control = DDCCheckBoxCellControl.init(cell: cell)
            control.configureCell(model: model, indexPath: indexPath)
            control.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCTitleTextFieldCell.self), for: indexPath) as! DDCTitleTextFieldCell
            let model: DDCContractInfoViewModel = self.models[indexPath.section]
            cell.configureCell(model: model, indexPath: indexPath, showHint: false)
            self.configureInputView(textField: cell.textFieldView.textField, indexPath: indexPath)
            cell.textFieldView.textField.tag = indexPath.section
            cell.textFieldView.textField.delegate = self
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0,
            kind == UICollectionView.elementKindSectionFooter {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: DDCContractHeaderFooterView.self), for: indexPath) as! DDCContractHeaderFooterView
            view.titleLabel.text = "请继续补充订单／合同信息"
            return view
        }
        
        if indexPath.section == 3,
            kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCSectionHeaderFooterView.self), for: indexPath) as! DDCSectionHeaderFooterView
            view.titleLabel.configure(title: "产品规格", isRequired: true)
            return view
        }
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: UICollectionReusableView.self), for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize.init(width: DDCAppConfig.width, height: 20)
        }  else if self.isPickedCustom && indexPath.section == 3 {
            var height: CGFloat = 42
            let customModel = self.customItems[indexPath.item]
            if customModel.attributes != nil{
                height = CGFloat((customModel.isSelected ? (customModel.attributes?.count)! + 1: 1 ) * 42)
            }
            return CGSize.init(width: DDCAppConfig.width, height: height)
        } else if self.model!.contractType == .personalSample && indexPath.section == 1 {
            return CGSize.init(width: DDCAppConfig.width, height: 0.01)
        }
        return CGSize.init(width: DDCAppConfig.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let top: CGFloat = (section == 0 || section == 3 ) ? 0: 20
        let bottom: CGFloat = (section == 0 || section == 3 ) ? 5: 25
        return UIEdgeInsets.init(top: top, left: DDCAppConfig.kLeftMargin, bottom: bottom, right: DDCAppConfig.kLeftMargin)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 || section == 3 {
            return CGFloat.leastNormalMagnitude
        }
        return 60.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 || section == 3 {
            return 20.0
        }
        return 50.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.init(width: DDCAppConfig.width, height: 70.0)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 3,
            self.isPickedCustom {
            return CGSize.init(width: DDCAppConfig.width, height: 40.0)
        }
        return CGSize.zero
    }
    
}

// MARK: API
extension DDCAddContractInfoViewController {
    
    func getPackagesForContract() {
        DDCTools.showHUD(view: self.view)
        DDCContractOptionsAPIManager.packagesForContract(storeId: self.model!.currentStore!.id!,type: (self.model?.contractType)!, successHandler: { [unowned self] (array) in
            DDCTools.hideHUD()
            if (array?.count)! > 0 {
                self.package = array!
                self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
            }
        }) { (error) in
            DDCTools.hideHUD()
        }
    }
    
    func getCustomCourse() {
        DDCTools.showHUD(view: self.view)
        DDCContractOptionsAPIManager.getCustomCourse(storeId: self.model!.currentStore!.id!, successHandler: { [unowned self] (array) in
            DDCTools.hideHUD()
            if let models = array {
                self.customItems = models
                self.resignFirstResponder()
                self.collectionView.reloadData()
            }
        }) { (error) in
            DDCTools.hideHUD()
        }
    }
    
    func getCourseSpec() {
        guard self.pickedPackage != nil else {
            return
        }
        DDCTools.showHUD(view: self.view)
        DDCContractOptionsAPIManager.getCourseSpec(packageId: (self.pickedPackage?.id)! , successHandler: { [unowned self] (array) in
            DDCTools.hideHUD()
            if let models = array {
                self.specs = models
            }
        }) { (error) in
            DDCTools.hideHUD()
        }
    }
    
}

// MARK: Textfield
extension DDCAddContractInfoViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if (textField.tag == DDCContractTextFieldType.money.rawValue && self.pickedPackage != nil && !self.isPickedCustom && !self.modifySkuPrice) {
            self.view.makeDDCToast(message: "该套餐不能修改价格", image: UIImage.init(named: "addCar_icon_fail")!)
            return false
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.currentTextField = textField
        self.pickerView.reloadAllComponents()
        if textField.tag == DDCContractTextFieldType.contraceNumber.rawValue ||  (textField.tag == DDCContractTextFieldType.money.rawValue && self.pickedPackage != nil && !self.isPickedCustom && !self.modifySkuPrice) || textField.tag == DDCContractTextFieldType.endDate.rawValue || textField.tag == DDCContractTextFieldType.effectiveDate.rawValue || textField.tag == DDCContractTextFieldType.store.rawValue {
            return false
        }
        if (textField.tag == DDCContractTextFieldType.startDate.rawValue && self.pickedPackage == nil) {
            self.view.makeDDCToast(message: "请选择套餐", image: UIImage.init(named: "addCar_icon_fail")!)
            return false
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == DDCContractTextFieldType.money.rawValue {
            let text: String = textField.text ?? ""
            if let price = Double(text) {
                self.model!.contractPrice = price
                self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
                self.collectionView.reloadData()
                self.formFilled()
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == DDCContractTextFieldType.money.rawValue {
            let text: String = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String
            //only number
            if (Double(text) == nil && text.count > 0) {//允许删除唯一一个字符
                return false
            } else {
                return true
            }
        }
        return true
    }
    
}

// MARK: Action
extension DDCAddContractInfoViewController {
    
    @objc override func cancel() {
        self.collectionView.reloadData()
        self.resignFirstResponder()
    }
    
    @objc override func done() {        
        let section = self.currentTextField?.tag
        switch section {
        case DDCContractTextFieldType.package.rawValue:
            do {
                guard self.package.count > 0 else {
                    return
                }
                self.choosePackage(package: self.package[self.pickerView.selectedRow(inComponent: 0)])
            }
        case DDCContractTextFieldType.spec.rawValue:
            do {
                guard self.pickedPackage != nil && self.specs.count > 0 else {
                    self.cancel()
                    return
                }
                self.checkBoxFilled = true
                self.chooseSpec(spec: self.specs[self.pickerView.selectedRow(inComponent: 0)])
            }
        case DDCContractTextFieldType.rule.rawValue:
            self.models[DDCContractTextFieldType.rule.rawValue].text = (self.orderRule[self.pickerView.selectedRow(inComponent: 0)] as! String)
            self.models[DDCContractTextFieldType.rule.rawValue].isFill = true
        case DDCContractTextFieldType.startDate.rawValue:
            do {
                let dateFormatter: DateFormatter = DateFormatter.init(withFormat: "YYYY/MM/dd", locale: "")
                let startDate: Date = self.datePickerView.date
                self.models[DDCContractTextFieldType.startDate.rawValue].text = dateFormatter.string(from: startDate)
                self.model?.packageModel?.startUseTime = DDCTools.dateToTimeInterval(from: startDate)
                if self.model?.specs != nil {
                    self.model!.packageModel!.endEffectiveTime = DDCTools.dateToTimeInterval(from: DDCTools.calculateCalendar(startDate: startDate, validPeriod: (self.model?.specs?.validPeriod)!))
                    self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
                    self.collectionView.reloadData()
                }
            }
        default:
            return
        }
        self.collectionView.reloadData()
        self.formFilled()
    }
    
    func choosePackage(package: DDCContractPackageModel) {
        self.pickedPackage = package
        self.modifySkuPrice = self.pickedPackage!.modifySkuPrice != nil ? self.pickedPackage!.modifySkuPrice! : false //确定是否价格可选
        //设置self.model的package对象
        self.model!.packageModel = self.pickedPackage
        self.model!.packageModel?.startUseTime = DDCTools.date(from: DDCAddContractInfoModelFactory.getStartDate(datetime: model?.packageModel?.startUseTime))
        self.model?.specs = nil //清空规格
        //models的刷新设置
        self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
        self.isPickedCustom = false  //默认不选择自选套餐
        
        if package.customSkuConfig == 1 {//选择自选套餐的情况
            self.isPickedCustom = true
            if self.customItems.count <= 0 { //没有加载过自选套餐时
                self.getCustomCourse()
                return
            } else { //已经有自选套餐数据时
                self.resignFirstResponder()
                self.collectionView.reloadData()
                return
            }
        } else {
            self.getCourseSpec()//获取规格数据
        }
    }

    func chooseSpec(spec: DDCContractPackageCategoryModel) {
        self.model?.specs = spec
        //计算结束日期和有效期
        self.model?.packageModel!.endEffectiveTime = DDCTools.dateToTimeInterval(from: DDCTools.calculateCalendar(startDate: DDCTools.datetime(from: model?.packageModel?.startUseTime), validPeriod: (spec.validPeriod)!))
        self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
    }
    
    override func forwardNextPage() {
        super.forwardNextPage()
        self.bottomBar.buttonArray![1].isEnabled = false
        
        if self.isPickedCustom {
            self.model?.customItems = self.reorganizeCustomData()
        }
        
        for index in 1...(self.models.count - 1) {
            let model: DDCContractInfoViewModel = self.models[index]
            if self.isCodeFilled , index == 1 {
                continue
            }
            if model.isRequired! ,
                (!model.isFill! && (model.text?.count)! <= 0) {
                self.bottomBar.buttonArray![0].isEnabled = true
                self.view.makeDDCToast(message: "信息填写不完整，请填写完整", image: UIImage.init(named: "addCar_icon_fail")!)
                return
            }
        }
        
        if (self.model?.contractPrice == nil) {
            self.model?.contractPrice = self.model?.specs?.costPrice ?? 0
        }
        
        DDCTools.showHUD(view: self.view)
        DDCCreateContractAPIManager.saveContract(model: self.model!, successHandler: { (result) in
            DDCTools.hideHUD()
            if self.model?.contractType == .personalSample {
                self.model?.code = result
            }
            self.delegate?.nextPage(model: self.model!)
        }) { (error) in
            DDCTools.hideHUD()
            self.bottomBar.buttonArray![1].isEnabled = true
            self.view.makeDDCToast(message: error, image: UIImage.init(named: "addCar_icon_fail")!)
        }
    }
    
}

extension DDCAddContractInfoViewController: DDCCheckBoxCellControlDelegate {
    func cellControl(_ control: DDCCheckBoxCellControl, didFinishEdited count: Int, isFilled: Bool) {
        var pickedSpec: Bool = false
        self.checkBoxFilled = false
        for idx in 0..<self.customItems.count {
            let item: DDCCourseModel = self.customItems[idx]
            if item.isSelected {
                pickedSpec = true
            }
        }
        if pickedSpec && isFilled {
            self.checkBoxFilled = true
        }
        if self.checkBoxFilled {
            self.model?.customItems =  self.reorganizeCustomData()
        }
        self.formFilled()
    }
    
    func cellControl(_ control: DDCCheckBoxCellControl, didSelectItemAt indexPath: IndexPath) {
        if self.customItems.count > 0 && indexPath.section == 3 {
            let items = self.customItems
            let model = items[indexPath.item]
            model.isSelected = !model.isSelected
            self.formFilled()
        }
        self.collectionView.reloadData()
    }
    
    override func formFilled() {
        super.formFilled()
        if  self.checkBoxFilled && (self.model?.contractPrice != nil || self.model?.specs?.costPrice != nil) &&  self.isCodeFilled {
            self.bottomBar.buttonArray![1].isEnabled = true
            self.bottomBar.buttonArray![1].setStyle(style: .highlighted)
        } else {
            self.bottomBar.buttonArray![1].isEnabled = false
            self.bottomBar.buttonArray![1].setStyle(style: .forbidden)
        }
    }
    
    func reorganizeCustomData() -> [DDCCourseModel]{
        var selectedItems: [DDCCourseModel] = Array()
        var totalcount: Int = 0
        let customItems: [DDCCourseModel] = self.customItems.map{($0.copy() as! DDCCourseModel) }
        //打包自选套餐数据
        for item in customItems {
            if item.isSelected == true {
                var attributes: [DDCCourseAttributeModel] = Array()
                if let _attributes = item.attributes {//有子产品
                    for att in _attributes {
                        if att.isSelected == true {
                            totalcount += att.totalCount
                            attributes.append(att)
                        }
                    }
                    item.attributes = attributes
                } else {
                    totalcount += item.totalCount
                }
                selectedItems.append(item)
            }
        }
        if selectedItems.count > 0 {
            //计算结束时间和有效期
            let validPeriod: Int = totalcount <= 48 ? totalcount : 48
            self.model!.packageModel!.endEffectiveTime = DDCTools.dateToTimeInterval(from: DDCTools.calculateCalendar(startDate: DDCTools.datetime(from: self.model?.packageModel?.startUseTime), validPeriod: validPeriod))
            //设置规格
            let spec: DDCContractPackageCategoryModel = DDCContractPackageCategoryModel()
            spec.validPeriod = validPeriod
            self.model!.specs = spec
            //刷新列表
            self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
            self.models[DDCContractTextFieldType.spec.rawValue].isFill = true
            self.collectionView.reloadData()
        }
        return selectedItems
    }
}
