//
//  DDCAddGroupContractInfoViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCAddContractInfoViewController: DDCChildContractViewController {
    enum DDCAddContractTextFieldType: Int{
        case none
        case contraceNumber
        case package
        case spec
        case rule
        case money
        case startDate
        case endDate
        case effectiveDate
        case store
    }
    
    var contractInfo: [DDCContractDetailsViewModel] = Array()
    var models: [DDCContractInfoViewModel] = Array()
    var currentTextField: UITextField?
    var items: [DDCCourseModel] = Array()
    var groupItems: (customCourses: [DDCCourseModel]?, sampleCourses: [DDCCourseModel]?)?
    var package: [DDCContractPackageModel] = Array()
    var specs: [DDCContractPackageCategoryModel] = Array()
    var contractType: DDCCourseType {
        get {
            return .group//self.model.contractType.id
        }
    }
    var groupCourses: [DDCCheckBoxModel] = [DDCCheckBoxModel.init(id: nil, title: "购买正式课程", discription: "", isSelected: false) ,DDCCheckBoxModel.init(id: nil, title: "购买体验课程", discription: "", isSelected: false)]
    
    
    var checkBoxControls: [DDCCheckBoxCellControl] = Array()
    var isPickedPackage: Bool = false
    var isPickedCustom: Bool = false
    var orderRule = ["跳过","遵守"]
    
    private lazy var datePickerView: UIDatePicker = {
        let _datePickerView = UIDatePicker.init(frame: CGRect.zero)
        _datePickerView.datePickerMode = .date
        _datePickerView.maximumDate = Date()
        return _datePickerView
    }()
    
    private lazy var pickerView: UIPickerView = {
        let _pickerView: UIPickerView = UIPickerView.init(frame: CGRect.zero)
        _pickerView.delegate = self
        _pickerView.dataSource = self
        return _pickerView
    }()
    
    private lazy var toolbar: DDCToolbar = {
        let _toolbar = DDCToolbar.init(frame: CGRect.init(x: 0, y: 0, width: screen.width, height: 40.0))
        _toolbar.doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        _toolbar.cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return _toolbar
    }()
    
    lazy var collectionView: UICollectionView! = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        
        var _collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        _collectionView.showsHorizontalScrollIndicator = false
        _collectionView.register(DDCContractDetailsCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DDCContractDetailsCollectionViewCell.self))
        _collectionView.register(DDCTitleTextFieldCell.self, forCellWithReuseIdentifier: String(describing: DDCTitleTextFieldCell.self))
        _collectionView.register(DDCCheckBoxCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DDCCheckBoxCollectionViewCell.self))
        _collectionView.register(DDCCheckBoxWithTitleCollectionCell.self, forCellWithReuseIdentifier: String(describing: DDCCheckBoxWithTitleCollectionCell.self))
        _collectionView.register(DDCContractHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: DDCContractHeaderFooterView.self))
        _collectionView.register(DDCSectionHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCSectionHeaderFooterView.self))
        _collectionView.register(DDCRadioHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCRadioHeaderView.self))
        _collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: UICollectionReusableView.self))
        
        _collectionView.backgroundColor = UIColor.white
        _collectionView.delegate = self
        _collectionView.dataSource = self
        return _collectionView
    }()
    
    private lazy var bottomBar: DDCBottomBar = {
        let _bottomBar: DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 10.0, y: 10.0, width: 10.0, height: 10.0))
        _bottomBar.addButton(button:DDCBarButton.init(title: "上一步", style: .normal, handler: {
            //            self.forwardNextPage()
        }))
        _bottomBar.addButton(button:DDCBarButton.init(title: "下一步", style: .forbidden, handler: {
            //            self.forwardNextPage()
        }))
        return _bottomBar
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.bottomBar)
        self.setupViewConstraints()
        self.contractInfo = DDCContractDetailsViewModelFactory.integrateContractData(model: self.model)
        self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:.group)//self.contractType
        if self.contractType == .group {
            self.getGroupCourse()
        } else {
            self.getPackagesForContract()
        }
    }
}

// MARK: Private
extension DDCAddContractInfoViewController {
    func configureInputView(textField: UITextField, indexPath: IndexPath) {
        switch indexPath.section {
        case DDCAddContractTextFieldType.package.rawValue,
             DDCAddContractTextFieldType.spec.rawValue,
             DDCAddContractTextFieldType.rule.rawValue:
            do {
                textField.inputAssistantItem.leadingBarButtonGroups = []
                textField.inputAssistantItem.trailingBarButtonGroups = []
                textField.inputView = self.pickerView
                textField.inputAccessoryView = self.toolbar
            }
            break
        case DDCAddContractTextFieldType.startDate.rawValue :
            do {
                textField.inputAssistantItem.leadingBarButtonGroups = []
                textField.inputAssistantItem.trailingBarButtonGroups = []
                textField.inputView = self.datePickerView
                textField.inputAccessoryView = self.toolbar
            }
            break
        default:
            do {
                textField.inputView = nil
                textField.inputAccessoryView = nil
                textField.keyboardType = .default
            }
            break
        }
    }
    
    func setupViewConstraints() {
        self.collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-DDCAppConfig.kBarHeight)
        }
        
        self.bottomBar.snp.makeConstraints({ (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(DDCAppConfig.kBarHeight)
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp_bottomMargin).offset(-DDCAppConfig.kBarHeight)
        })
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
        }
        if self.contractType == .group &&  (section == 3 || section == 2){
            if self.groupItems == nil {
                return 0
            }
            if section == 3 {
                return (self.groupItems?.sampleCourses!.count)!
            } else {
                return (self.groupItems?.customCourses!.count)!
            }
        } else {
            if self.isPickedCustom && section == 3 {
                return self.items.count
            }
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
        }
        if self.contractType == .group{
            return self.collectionViewGroupCell(collectionView, cellForItemAt: indexPath)
        } else {
            return self.collectionViewRegularCell(collectionView, cellForItemAt: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0,
            kind == UICollectionView.elementKindSectionFooter {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: DDCContractHeaderFooterView.self), for: indexPath) as! DDCContractHeaderFooterView
            view.titleLabel.text = "请继续补充订单／合同信息"
            return view
        }
        if self.contractType == .group{
            if indexPath.section == 2 || indexPath.section == 3,
                kind == UICollectionView.elementKindSectionHeader {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCRadioHeaderView.self), for: indexPath) as! DDCRadioHeaderView
                let model = self.groupCourses[indexPath.section - 2]
                if indexPath.section == 2 {
                    view.type = .title
                    view.titleLabel.configure(title: "产品规格", isRequired: true)
                } else {
                    view.type = .normal
                }
                view.radioButton.button.setTitle(model.title, for: .normal)
                view.radioButton.button.isSelected = model.isSelected
                return view
            }
        } else {
            if indexPath.section == 3,
                kind == UICollectionView.elementKindSectionHeader {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCSectionHeaderFooterView.self), for: indexPath) as! DDCSectionHeaderFooterView
                view.titleLabel.configure(title: "产品规格", isRequired: true)
                return view
            }
        }
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: UICollectionReusableView.self), for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize.init(width: DDCAppConfig.width, height: 20)
        }  else if self.items.count > 0 && indexPath.section == 3 {
            return CGSize.init(width: DDCAppConfig.width, height: self.checkBoxControls.count > 0 ?self.checkBoxControls[indexPath.item].cellHeight(): 30)
        } else if self.contractType == DDCCourseType.sample && indexPath.section == 1 {
            return CGSize.zero
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
        if self.contractType == .group && (section == 2 || section == 3){
            return CGSize.init(width: DDCAppConfig.width, height: 60.0)
        }else if section == 3,
            self.items.count > 0{
            return CGSize.init(width: DDCAppConfig.width, height: 40.0)
        }
        return CGSize.zero
    }
    
    func collectionViewGroupCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell  {
        if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCCheckBoxWithTitleCollectionCell.self), for: indexPath) as! DDCCheckBoxWithTitleCollectionCell
            let model: DDCCourseModel = (self.groupItems?.customCourses![indexPath.item])!
            let control = DDCCheckBoxCellControl.init(cell: cell)
            control.configureCell(model: model, indexPath: indexPath)
            self.checkBoxControls.insert(control, at: indexPath.item)
            return cell
        } else if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCCheckBoxWithTitleCollectionCell.self), for: indexPath) as! DDCCheckBoxWithTitleCollectionCell
            let model: DDCCourseModel = (self.groupItems?.sampleCourses![indexPath.item])!
            let control = DDCCheckBoxCellControl.init(cell: cell)
            //            control.configureCell(model: model, indexPath: indexPath)
            cell.checkBox.button.setTitle(model.courseName, for: .normal)
            cell.checkBox.button.isSelected = model.isSelected
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
    
    func collectionViewRegularCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell  {
        if self.isPickedCustom && indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCCheckBoxCollectionViewCell.self), for: indexPath) as! DDCCheckBoxCollectionViewCell
            let model: DDCCourseModel = self.items[indexPath.item]
            let control = DDCCheckBoxCellControl.init(cell: cell)
            control.configureCell(model: model, indexPath: indexPath)
            self.checkBoxControls.insert(control, at: indexPath.item)
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
}

extension DDCAddContractInfoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.contractType == .group{
            var course: DDCCheckBoxModel?
            for index in 0...(self.groupCourses.count - 1) {
                course = self.groupCourses[index]
                if indexPath.row == index {
                    course!.isSelected = true
                } else {
                    course!.isSelected = false
                }
            }
        } else {
            if self.items.count > 0 && indexPath.section == 3 {
                let items = self.items
                
                let model = items[indexPath.item]
                model.isSelected = !model.isSelected
            }
        }
        
        self.collectionView.reloadData()//.reloadSections([indexPath.section])
    }
    
}

// MARK: API
extension DDCAddContractInfoViewController {
    
    func getPackagesForContract() {
        DDCTools.showHUD(view: self.view)//(self.model?.currentStore?.id)!
        DDCContractOptionsAPIManager.packagesForContract(storeId: 4, successHandler: { (array) in
            DDCTools.hideHUD()
            if (array?.count)! > 0 {
                self.package = array!
            }
        }) { (error) in
            
        }
    }
    
    func getCustomCourse() {
        DDCTools.showHUD(view: self.view)//(self.model?.currentStore?.id)!
        DDCContractOptionsAPIManager.getCustomCourse(storeId: 4, successHandler: { (array) in
            DDCTools.hideHUD()
            if let models = array {
                self.items = models
                self.collectionView.reloadData()
            }
        }) { (error) in
            
        }
    }
    
    func getGroupCourse() {
        DDCTools.showHUD(view: self.view)
        DDCContractOptionsAPIManager.getGroupCourse(storeId: 4, successHandler: { (tuple) in
            DDCTools.hideHUD()
            self.groupItems = tuple
            self.collectionView.reloadData()
        }) { (error) in
            
        }
    }
}

// MARK: PickerView
extension DDCAddContractInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch self.currentTextField?.tag {
        case DDCAddContractTextFieldType.package.rawValue:
            return self.package.count
        case DDCAddContractTextFieldType.spec.rawValue:
            do {
                guard self.isPickedPackage else {
                    return 1
                }
                return self.specs.count
            }
        case DDCAddContractTextFieldType.rule.rawValue:
            return self.orderRule.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch self.currentTextField?.tag {
        case DDCAddContractTextFieldType.package.rawValue:
            return self.package[row].name
        case DDCAddContractTextFieldType.spec.rawValue:
            do {
                guard self.isPickedPackage else {
                    return "请先选择套餐"
                }
                return "\(self.specs[row].name ?? "") - \(self.specs[row].costPrice ?? 0)"
            }
        case DDCAddContractTextFieldType.rule.rawValue:
            return self.orderRule[row]
        default:
            return ""
        }
    }
    
}

// MARK: Textfield
extension DDCAddContractInfoViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.currentTextField = textField
        if textField.tag == DDCAddContractTextFieldType.contraceNumber.rawValue ||  (textField.tag == DDCAddContractTextFieldType.money.rawValue && !self.isPickedPackage) || textField.tag == DDCAddContractTextFieldType.endDate.rawValue || textField.tag == DDCAddContractTextFieldType.effectiveDate.rawValue || textField.tag == DDCAddContractTextFieldType.store.rawValue{
            return false
        }
        return true
    }
    
}

// MARK: Action
extension DDCAddContractInfoViewController {
    @objc func done() {
        let section = self.currentTextField?.tag
        switch section {
        case DDCAddContractTextFieldType.package.rawValue:
            do {
                self.models[DDCAddContractTextFieldType.package.rawValue].text = self.package[self.pickerView.selectedRow(inComponent: 0)].name
                self.models[DDCAddContractTextFieldType.package.rawValue].isFill = true
                self.isPickedPackage = true
                self.isPickedCustom = false
                self.specs = self.package[self.pickerView.selectedRow(inComponent: 0)].skuList!
                if self.pickerView.selectedRow(inComponent: 0) == 1 {
                    self.isPickedCustom = true
                    if self.items.count <= 0 {
                        self.getCustomCourse()
                    } else {
                        self.collectionView.reloadData()
                    }
                    return
                }
            }
        case DDCAddContractTextFieldType.spec.rawValue:
            do {
                guard self.isPickedPackage else {
                    self.cancel()
                    return
                }
                self.models[DDCAddContractTextFieldType.spec.rawValue].text = "\(self.specs[self.pickerView.selectedRow(inComponent: 0)].name ?? "") - \(self.specs[self.pickerView.selectedRow(inComponent: 0)].costPrice ?? 0)"
                self.models[DDCAddContractTextFieldType.spec.rawValue].isFill = true
                self.models[DDCAddContractTextFieldType.money.rawValue].text = "\(self.specs[self.pickerView.selectedRow(inComponent: 0)].costPrice ?? 0)"
                self.models[DDCAddContractTextFieldType.money.rawValue].isFill = true
            }
        case DDCAddContractTextFieldType.rule.rawValue:
            self.models[DDCAddContractTextFieldType.rule.rawValue].text = self.orderRule[self.pickerView.selectedRow(inComponent: 0)]
            self.models[DDCAddContractTextFieldType.rule.rawValue].isFill = true
        case DDCAddContractTextFieldType.startDate.rawValue:
            do {
                let dateFormatter: DateFormatter = DateFormatter.init(withFormat: "YYYY/MM/dd", locale: "")
                let startDate: Date = self.datePickerView.date
                self.models[DDCAddContractTextFieldType.startDate.rawValue].text = dateFormatter.string(from: startDate)
            }
        default:
            return
        }
        self.collectionView.reloadData()
        self.resignFirstResponder()
    }
    
    @objc func cancel() {
        self.collectionView.reloadData()
        self.resignFirstResponder()
    }
}
