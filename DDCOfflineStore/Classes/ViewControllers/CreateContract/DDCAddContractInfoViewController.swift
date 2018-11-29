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
    var customItems: [DDCCourseModel] = Array()
    var package: [DDCContractPackageModel] = Array()
    var specs: [DDCContractPackageCategoryModel] = Array()

    var checkBoxControls: [DDCCheckBoxCellControl] = Array()
    var pickedPackage: DDCContractPackageModel?
    var isPickedCustom: Bool = false
    var orderRule: NSArray = ["跳过","遵守"]
    var checkBoxFilled: Bool = false
    var modifySkuPrice: Bool = false
    var isCodeFilled: Bool {
        get {
            return (self.model?.courseType == .sample) ? true : self.model?.code != nil
        }
    }

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

        self.getPackagesForContract()
        self.getRelationShopOptions()
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
        }
        
        return self.collectionViewRegularCell(collectionView, cellForItemAt: indexPath)
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
            var height: CGFloat = 30
            let customModel = self.customItems[indexPath.item]
            if customModel != nil && customModel.attributes != nil{
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
            self.customItems.count > 0{
            return CGSize.init(width: DDCAppConfig.width, height: 40.0)
        }
        return CGSize.zero
    }
    
    func collectionViewRegularCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell  {
        if self.isPickedCustom && indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCCheckBoxCollectionViewCell.self), for: indexPath) as! DDCCheckBoxCollectionViewCell
            let model: DDCCourseModel = self.customItems[indexPath.item]
            let control = DDCCheckBoxCellControl.init(cell: cell)
            control.configureCell(model: model, indexPath: indexPath)
            control.delegate = self
//            self.checkBoxControls.insert(control, at: indexPath.item)
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
        
        
    }
    
}

// MARK: API
extension DDCAddContractInfoViewController {
    
    func getPackagesForContract() {
        DDCTools.showHUD(view: self.view)
        DDCContractOptionsAPIManager.packagesForContract(storeId: self.model!.currentStore!.id!, successHandler: { (array) in
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
        DDCContractOptionsAPIManager.getCustomCourse(storeId: self.model!.currentStore!.id!, successHandler: { (array) in
            DDCTools.hideHUD()
            if let models = array {
                self.customItems = models
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
        DDCContractOptionsAPIManager.getCourseSpec(packageId: (self.pickedPackage?.id)! , successHandler: { (array) in
            DDCTools.hideHUD()
            if let models = array {
                self.specs = models
            }
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
                guard self.pickedPackage != nil else {
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
                guard self.pickedPackage != nil else {
                    return "请先选择套餐"
                }
                return "\(self.specs[row].name ?? "") - \(self.specs[row].costPrice ?? 0)"
            }
        case DDCAddContractTextFieldType.rule.rawValue:
            return (self.orderRule[row] as! String)
        default:
            return ""
        }
    }
    
}

// MARK: Textfield
extension DDCAddContractInfoViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.currentTextField = textField
        if textField.tag == DDCAddContractTextFieldType.contraceNumber.rawValue ||  (textField.tag == DDCAddContractTextFieldType.money.rawValue && self.pickedPackage != nil && !self.isPickedCustom && !self.modifySkuPrice) || textField.tag == DDCAddContractTextFieldType.endDate.rawValue || textField.tag == DDCAddContractTextFieldType.effectiveDate.rawValue || textField.tag == DDCAddContractTextFieldType.store.rawValue{
            return false
        }
        if textField.tag == DDCAddContractTextFieldType.rule.rawValue {
            self.pickerView.selectRow(self.orderRule.index(of: textField.text as Any), inComponent: 0, animated: true)
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == DDCAddContractTextFieldType.money.rawValue {
            self.model!.contractPrice = Int(textField.text!)!
            self.models[textField.tag].text = textField.text
            self.models[textField.tag].isFill = true
            self.formFilled()
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
                guard self.package.count > 0 else {
                    return
                }
                self.pickedPackage = self.package[self.pickerView.selectedRow(inComponent: 0)]
                self.modifySkuPrice = self.pickedPackage!.modifySkuPrice != nil ? self.pickedPackage!.modifySkuPrice! : false
                self.model!.packageModel = self.pickedPackage
                self.model!.packageModel?.startUseTime = DDCTools.date(from: DDCAddContractInfoModelFactory.getStartDate(datetime: model?.packageModel?.startUseTime))
                self.model?.specs = nil //清空规格
                self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
                self.models[DDCAddContractTextFieldType.spec.rawValue].text = ""
                self.models[DDCAddContractTextFieldType.spec.rawValue].isFill = false
                self.isPickedCustom = false
                if self.pickerView.selectedRow(inComponent: 0) == 1 {
                    self.isPickedCustom = true
                    if self.customItems.count <= 0 {
                        self.getCustomCourse()
                    } else {
                        self.collectionView.reloadData()
                    }
                    return
                } else {
                    self.getCourseSpec()
                }
            }
        case DDCAddContractTextFieldType.spec.rawValue:
            do {
                guard self.pickedPackage != nil else {
                    self.cancel()
                    return
                }
                self.checkBoxFilled = true
                let spec: DDCContractPackageCategoryModel = self.specs[self.pickerView.selectedRow(inComponent: 0)]
                self.model?.specs = spec
                let endTime = (spec != nil) ? spec.validPeriod : 0
                let calendar: Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
                var components: DateComponents = DateComponents.init()
                components.setValue(endTime, for: .month)
                let maxDate: Date = calendar.date(byAdding: components, to: DDCTools.datetime(from: model?.packageModel?.startUseTime))!
                self.model?.packageModel!.endEffectiveTime = DDCTools.dateToTimeInterval(from: maxDate)
                self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
            }
        case DDCAddContractTextFieldType.rule.rawValue:
            self.models[DDCAddContractTextFieldType.rule.rawValue].text = self.orderRule[self.pickerView.selectedRow(inComponent: 0)] as! String
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
        self.resignFirstResponder()
        self.collectionView.reloadData()
        self.formFilled()
    }
    
    @objc func cancel() {
        self.collectionView.reloadData()
        self.resignFirstResponder()
    }
   
    func forwardNextPage() {
        self.bottomBar.buttonArray![1].isEnabled = false
        
        if self.isPickedCustom {
            var customItems: [DDCCourseModel] = Array()
            var totalcount: Int = 0
            
            for item in self.customItems {
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
                let maxDate: Date = calendar.date(byAdding: components, to: DDCTools.datetime(from: self.model?.packageModel?.startUseTime))!
                self.model!.packageModel!.endEffectiveTime = DDCTools.dateToTimeInterval(from: maxDate)
                self.models[DDCAddContractTextFieldType.spec.rawValue].isFill = true
                self.model!.customItems = customItems
            }
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
    
    @objc func scanAction(_ sender: AnyObject) {
        self.qrCodeReader.delegate = self
        
        self.qrCodeReader.completionBlock = { (result: QRCodeReaderResult?) in
//            self.models[DDCAddContractTextFieldType.contraceNumber.rawValue].text = "www-ddc-123123"//result?.value
//            self.models[DDCAddContractTextFieldType.contraceNumber.rawValue].isFill = true
//            self.model?.code = "www-ddc-123123"//result?.value
//            self.collectionView.reloadSections([1])
            if DDCTools.isQualifiedCode(qrCode: result?.value) {
                self.models[DDCAddContractTextFieldType.contraceNumber.rawValue].text = result?.value
                self.models[DDCAddContractTextFieldType.contraceNumber.rawValue].isFill = true
                self.model?.code = result?.value
                self.collectionView.reloadSections([1])
            } else {
                self.view.makeDDCToast(message:"二维码错误", image: UIImage.init(named: "addCar_icon_fail")!)
            }
        }
        
        // Presents the readerVC as modal form sheet
        self.qrCodeReader.modalPresentationStyle = .overFullScreen
        present(self.qrCodeReader, animated: true, completion: nil)
    }
    
}

// MARK: - QRCodeReaderViewController Delegate
extension DDCAddContractInfoViewController: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
}

extension DDCAddContractInfoViewController: DDCCheckBoxCellControlDelegate {
    func cellControl(_ control: DDCCheckBoxCellControl, didFinishEdited count: Int, isFilled: Bool) {
        self.checkBoxFilled = isFilled
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
    
    func formFilled() {
        if self.checkBoxFilled && (self.model?.contractPrice != nil || self.model?.specs?.costPrice != nil) &&  self.isCodeFilled {
            self.bottomBar.buttonArray![1].isEnabled = true
            self.bottomBar.buttonArray![1].setStyle(style: .highlighted)
        } else {
            self.bottomBar.buttonArray![1].isEnabled = false
            self.bottomBar.buttonArray![1].setStyle(style: .forbidden)
        }
    }
}
