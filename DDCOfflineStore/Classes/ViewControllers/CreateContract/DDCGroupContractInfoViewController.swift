//
//  DDCGroupContractInfoViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader

class DDCGroupContractInfoViewController: DDCChildContractViewController {
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
    var groupItems: (customCourses: [DDCCourseModel]?, sampleCourses: [DDCCourseModel]?)?
    var package: [DDCContractPackageModel] = Array()
    var specs: [DDCContractPackageCategoryModel] = Array()

    var groupCourses: [DDCCheckBoxModel] = [DDCCheckBoxModel.init(id: nil, title: "购买正式课程", discription: "", isSelected: false) ,DDCCheckBoxModel.init(id: nil, title: "购买体验课程", discription: "", isSelected: false)]
    var pickedSection: Int = 999
    
    var customCoursesControls: [DDCCheckBoxCellControl] = Array()
    
    var isPickedPackage: Bool = false
    var orderRule: NSArray = ["跳过","遵守"]
    var checkBoxFilled: Bool = false
    var upgradeLimit: Int = 0

    lazy var qrCodeReader: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        return QRCodeReaderViewController(builder: builder)
    }()
    
    private lazy var datePickerView: UIDatePicker = {
        let _datePickerView = UIDatePicker.init(frame: CGRect.zero)
        _datePickerView.datePickerMode = .date
        //可修改期间范围为前2个月+后4个月
        var calendar: Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        var components: DateComponents = DateComponents.init()
        components.setValue(-2, for: .month)
        var minDate: Date = calendar.date(byAdding: components, to: Date())!
        components.setValue(4, for: .month)
        var maxDate: Date = calendar.date(byAdding: components, to: Date())!
        _datePickerView.minimumDate = minDate
        _datePickerView.maximumDate = maxDate
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
        _collectionView.register(DDCTextFieldButtonCell.self, forCellWithReuseIdentifier: String(describing: DDCTextFieldButtonCell.self))
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
        let _bottomBar: DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 10.0, y: 10.0, width: screen.width, height: DDCAppConfig.kBarHeight))
        _bottomBar.addButton(button:DDCBarButton.init(title: "上一步", style: .normal, handler: {
            self.delegate?.previousPage(model: self.model!)
        }))
        _bottomBar.addButton(button:DDCBarButton.init(title: "下一步", style: .forbidden, handler: {
            self.forwardNextPage()
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
        self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
        self.getGroupCourse()
        self.getRelationShopOptions()
    }
}

// MARK: Private
extension DDCGroupContractInfoViewController {
    func configureInputView(textField: UITextField, indexPath: IndexPath) {
        switch indexPath.section {
        case DDCAddContractTextFieldType.package.rawValue,
             DDCAddContractTextFieldType.spec.rawValue:
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
extension DDCGroupContractInfoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.contractInfo.count
        }else if  (section == 3 || section == 2){
            if self.groupItems == nil {
                return 0
            }
            if section == 3 {
                return (self.groupItems?.sampleCourses!.count)!
            } else {
                return (self.groupItems?.customCourses!.count)!
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
        
        return self.collectionViewGroupCell(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0,
            kind == UICollectionView.elementKindSectionFooter {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: DDCContractHeaderFooterView.self), for: indexPath) as! DDCContractHeaderFooterView
            view.titleLabel.text = "请继续补充订单／合同信息"
            return view
        }else if indexPath.section == 2 || indexPath.section == 3,
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
            view.tag = indexPath.section
            view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(headerSelected(gesture:))))
            return view
        }
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: UICollectionReusableView.self), for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize.init(width: DDCAppConfig.width, height: 20)
        }else if indexPath.section == 2 {
            if indexPath.section == (self.pickedSection + 2) {
                var height: CGFloat = 30
                let customModel: DDCCourseModel = (self.groupItems?.customCourses![indexPath.item])!
                if customModel != nil && customModel.attributes != nil{
                    height = CGFloat((customModel.isSelected ? (customModel.attributes?.count)! + 1: 1 ) * 42)
                }
                return CGSize.init(width: DDCAppConfig.width, height: height)
            }
            return CGSize.zero
        } else if indexPath.section == 3 {
            if indexPath.section ==  (self.pickedSection + 2)  {
                return CGSize.init(width: DDCAppConfig.width, height: 45)
            }
            return CGSize.zero
        }
        return CGSize.init(width: DDCAppConfig.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let top: CGFloat = (section == 0 || section == 3) ? 0: 20
        let bottom: CGFloat = (section == 0 || section == 3 || section == 2 ) ? 5: 25
        return UIEdgeInsets.init(top: top, left: DDCAppConfig.kLeftMargin, bottom: bottom, right: DDCAppConfig.kLeftMargin)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 || section == 3 || section == 2 {
            return CGFloat.leastNormalMagnitude
        }
        return 60.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 || section == 3 || section == 2 {
            return 20.0
        }
        return 50.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.init(width: DDCAppConfig.width, height: 70.0)
        }
        return CGSize.init(width: DDCAppConfig.width, height: 0.01)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if  section == 2 || section == 3 {
            return CGSize.init(width: DDCAppConfig.width, height: section == 2 ? 80.0 : 60.0)
        }
        return CGSize.init(width: DDCAppConfig.width, height: 0.01)
    }
    
    func collectionViewGroupCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell  {
        if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCCheckBoxCollectionViewCell.self), for: indexPath) as! DDCCheckBoxCollectionViewCell
            let model: DDCCourseModel = (self.groupItems?.customCourses![indexPath.item])!
            let control = DDCCheckBoxCellControl.init(cell: cell)
            control.delegate = self
            control.configureCell(model: model, indexPath: indexPath)
            self.customCoursesControls.insert(control, at: indexPath.item)
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCTextFieldButtonCell.self), for: indexPath) as! DDCTextFieldButtonCell
            let model: DDCContractInfoViewModel = self.models[indexPath.section]
            cell.configureCell(model: model, indexPath: indexPath, showHint: false)
            self.configureInputView(textField: cell.textFieldView.textField, indexPath: indexPath)
            cell.textFieldView.textField.tag = indexPath.section
            cell.textFieldView.textField.delegate = self
            cell.button.addTarget(self, action: #selector(scanAction(_:)), for: .touchUpInside)
            return cell
        } else if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCCheckBoxCollectionViewCell.self), for: indexPath) as! DDCCheckBoxCollectionViewCell
            let model: DDCCourseModel = (self.groupItems?.sampleCourses![indexPath.item])!
            let control = DDCCheckBoxCellControl.init(cell: cell)
            control.delegate = self
            control.configureCell(model: model, indexPath: indexPath)
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

extension DDCGroupContractInfoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if (self.groupItems?.customCourses!.count)! > 0 {
                let items = self.groupItems?.customCourses!
                let model = items![indexPath.item]
                model.isSelected = !model.isSelected
            }
        } else {
            if (self.groupItems?.sampleCourses!.count)! > 0 {
                let items = self.groupItems?.sampleCourses!
                let model = items![indexPath.item]
                model.isSelected = !model.isSelected
            }
        }
        
        self.collectionView.reloadData()//.reloadSections([indexPath.section])
    }
    
}

// MARK: API
extension DDCGroupContractInfoViewController {
    
    func getGroupCourse() {
        DDCTools.showHUD(view: self.view)
        DDCContractOptionsAPIManager.getGroupCourse(storeId: 4, successHandler: { (tuple) in
            DDCTools.hideHUD()
            self.groupItems = tuple
            self.collectionView.reloadData()
        }) { (error) in
            DDCTools.hideHUD()
        }
    }
    
    func getRelationShopOptions() {
        DDCStoreOptionsAPIManager.getRelationShopOptions(currentStoreId: (self.model?.currentStore?.id)!, successHandler: { (stores) in
            self.model?.relationShops = stores
            self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
            self.collectionView.reloadSections([self.models.count - 1])
        }) { (error) in
            
        }
    }
}

// MARK: PickerView
extension DDCGroupContractInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
            return self.orderRule[row] as! String
        default:
            return ""
        }
    }
    
}

// MARK: Textfield
extension DDCGroupContractInfoViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.currentTextField = textField
        if textField.tag == DDCAddContractTextFieldType.contraceNumber.rawValue || textField.tag == DDCAddContractTextFieldType.endDate.rawValue || textField.tag == DDCAddContractTextFieldType.effectiveDate.rawValue || textField.tag == DDCAddContractTextFieldType.store.rawValue || textField.tag == DDCAddContractTextFieldType.rule.rawValue{
            return false
        } else if textField.tag == DDCAddContractTextFieldType.rule.rawValue {
            self.pickerView.selectRow(self.orderRule.index(of: textField.text as Any), inComponent: 0, animated: true)
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == DDCAddContractTextFieldType.money.rawValue {
            self.model!.contractPrice = Int(textField.text!)
            self.models[textField.tag].text = textField.text
            self.models[textField.tag].isFill = true
            self.formFilled()
        }
        
        return true
    }
}

// MARK: Action
extension DDCGroupContractInfoViewController {
    func forwardNextPage() {
        //        self.bottomBar.buttonArray![1].isEnabled = false
        
        if self.model?.contractType == .groupRegular {
            self.wrapItems(models: (self.groupItems?.customCourses)!)
        } else {
            self.wrapItems(models: (self.groupItems?.sampleCourses)!)
        }
        
        for index in 1...(self.models.count - 1) {
            let model: DDCContractInfoViewModel = self.models[index]
            if model.isRequired! ,
                (!model.isFill! && (model.text?.count)! <= 0) {
                self.bottomBar.buttonArray![0].isEnabled = true
                self.view.makeDDCToast(message: "信息填写不完整，请填写完整", image: UIImage.init(named: "addCar_icon_fail")!)
                return
            }
        }
        
        DDCTools.showHUD(view: self.view)
        DDCCreateContractAPIManager.saveContract(model: self.model!, successHandler: { (code) in
            DDCTools.hideHUD()
            self.model?.code = code
            self.delegate?.nextPage(model: self.model!)
        }) { (error) in
            DDCTools.hideHUD()
            self.bottomBar.buttonArray![1].isEnabled = true
        }
    }
    
    @objc func done() {
        let section = self.currentTextField?.tag
        switch section {
//        case DDCAddContractTextFieldType.package.rawValue:
//            do {
//                self.models[DDCAddContractTextFieldType.package.rawValue].text = self.package[self.pickerView.selectedRow(inComponent: 0)].name
//                self.models[DDCAddContractTextFieldType.package.rawValue].isFill = true
//                self.isPickedPackage = true
//                self.isPickedCustom = false
////                self.specs = self.package[self.pickerView.selectedRow(inComponent: 0)].skuList!
//                if self.pickerView.selectedRow(inComponent: 0) == 1 {
//                    self.isPickedCustom = true
//                    self.collectionView.reloadData()
//                    return
//                }
//            }
//        case DDCAddContractTextFieldType.spec.rawValue:
//            do {
//                guard self.isPickedPackage else {
//                    self.cancel()
//                    return
//                }
//                self.models[DDCAddContractTextFieldType.spec.rawValue].text = "\(self.specs[self.pickerView.selectedRow(inComponent: 0)].name ?? "") - \(self.specs[self.pickerView.selectedRow(inComponent: 0)].costPrice ?? 0)"
//                self.models[DDCAddContractTextFieldType.spec.rawValue].isFill = true
//                self.models[DDCAddContractTextFieldType.money.rawValue].text = "\(self.specs[self.pickerView.selectedRow(inComponent: 0)].costPrice ?? 0)"
//                self.models[DDCAddContractTextFieldType.money.rawValue].isFill = true
//            }
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
    
    @objc func headerSelected(gesture: UITapGestureRecognizer) {
        var course: DDCCheckBoxModel?
        let index = (gesture.view?.tag)! - 2
        self.pickedSection = index
        if index == 0 {
            self.model?.contractType = .groupRegular
        } else {
            self.model?.contractType = .groupSample
        }
        for idx in 0...(self.groupCourses.count - 1) {
            course = self.groupCourses[idx]
            if index == idx {
                course!.isSelected = true
            } else {
                course!.isSelected = false
            }
        }
        self.collectionView.reloadData()
    }
    
    @objc func scanAction(_ sender: AnyObject) {
        self.qrCodeReader.delegate = self
        
        self.qrCodeReader.completionBlock = { (result: QRCodeReaderResult?) in
            if DDCTools.isQualifiedCode(qrCode: (result?.value)!) {
                self.models[DDCAddContractTextFieldType.contraceNumber.rawValue].text = result?.value
                self.models[DDCAddContractTextFieldType.contraceNumber.rawValue].isFill = true
                self.model?.code = result?.value
                self.collectionView.reloadSections([1])
                self.formFilled()
            } else {
                self.view.makeDDCToast(message:"二维码错误", image: UIImage.init(named: "addCar_icon_fail")!)
            }
        }
        
        // Presents the readerVC as modal form sheet
        self.qrCodeReader.modalPresentationStyle = .overFullScreen
        present(self.qrCodeReader, animated: true, completion: nil)
    }
    
    func wrapItems(models: [DDCCourseModel]) {
        var customItems: [DDCCourseModel] = Array()
        var totalcount: Int = 0
        
        for item in models {
            if item.isSelected == true {
                var attributes: [DDCCourseAttributeModel] = Array()
                if let _attributes = item.attributes {
                    for att in _attributes {
                        if att.isSelected == true {
                            totalcount += att.totalCount
                            attributes.append(att)
                        }
                    }
                    item.attributes = attributes
                }
                customItems.append(item)
            }
        }
        if customItems.count > 0 {
            let calendar: Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
            var components: DateComponents = DateComponents.init()
            components.setValue(totalcount, for: .month)
            let packageModel: DDCContractPackageModel = DDCContractPackageModel()
            let startTime: CLong = model?.packageModel?.startUseTime != nil ? (model?.packageModel?.startUseTime)! : DDCTools.dateToTimeInterval(from: Date())
            let maxDate: Date = calendar.date(byAdding: components, to: DDCTools.datetime(from: startTime))!
            packageModel.endEffectiveTime = DDCTools.dateToTimeInterval(from: maxDate)
            packageModel.startUseTime = startTime
            packageModel.packageType = .aging
            packageModel.upgradeLimit = self.upgradeLimit
            if self.model?.contractType == .groupRegular{
                packageModel.packageType = .category
            }
            self.model?.packageModel = packageModel
            self.models[DDCAddContractTextFieldType.package.rawValue].isFill = true
            self.models[DDCAddContractTextFieldType.spec.rawValue].isFill = true
            self.model!.customItems = customItems
        }
    }
}

// MARK: - QRCodeReaderViewController Delegate
extension DDCGroupContractInfoViewController: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
}

extension DDCGroupContractInfoViewController: DDCCheckBoxCellControlDelegate {
    func cellControl(_ control: DDCCheckBoxCellControl, didFinishEdited count: Int, isFilled: Bool) {
        self.checkBoxFilled = isFilled
        self.formFilled()
    }
    
    func cellControl(_ control: DDCCheckBoxCellControl, didSelectItemAt indexPath: IndexPath) {
        if (self.groupItems?.sampleCourses!.count)! > 0 && indexPath.section == 3 {
            let items = self.groupItems?.sampleCourses
            let model = items![indexPath.item]
            model.isSelected = !model.isSelected
            self.formFilled()
        }
        self.collectionView.reloadData()
    }
    
    func formFilled() {
        var pickedSpec: Bool = false
        if let items: [DDCCourseModel] = self.groupItems?.customCourses {
            for idx in 0..<items.count {
                let item: DDCCourseModel = items[idx]
                if item.totalCount > 0 {
                    pickedSpec = true
                }
            }
        }

        if pickedSpec && self.checkBoxFilled && (self.model?.contractPrice != nil || self.model?.specs?.costPrice != nil) && self.model?.code != nil{
            self.bottomBar.buttonArray![1].isEnabled = true
            self.bottomBar.buttonArray![1].setStyle(style: .highlighted)
        } else {
            self.bottomBar.buttonArray![1].isEnabled = false
            self.bottomBar.buttonArray![1].setStyle(style: .forbidden)
        }
    }
}
