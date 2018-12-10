//
//  DDCContractInfoViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/23.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader

class DDCContractInfoViewController: DDCChildContractViewController {
    enum DDCContractTextFieldType: Int{
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
  
    var orderRule: NSArray = ["跳过","遵守"]
    var package: [DDCContractPackageModel] = Array()
    var specs: [DDCContractPackageCategoryModel] = Array()

    var pickedPackage: DDCContractPackageModel?
//    var isPickedCustom: Bool = false
//    var checkBoxFilled: Bool = false
//    var modifySkuPrice: Bool = false
//    var isCodeFilled: Bool {
//        get {
//            return (self.model?.courseType == .sample) ? true : self.model?.code != nil
//        }
//    }
    var model: DDCContractModel? {
        get {
            return _model
        }
    }

//    lazy var qrCodeReader: QRCodeReaderViewController = {
//        let builder = QRCodeReaderViewControllerBuilder {
//            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
//        }
//        return QRCodeReaderViewController(builder: builder)
//    }()

    lazy var datePickerView: UIDatePicker = {
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

    lazy var pickerView: UIPickerView = {
        let _pickerView: UIPickerView = UIPickerView.init(frame: CGRect.zero)
        _pickerView.delegate = self
        _pickerView.dataSource = self
        return _pickerView
    }()

    lazy var toolbar: DDCToolbar = {
        let _toolbar = DDCToolbar.init(frame: CGRect.init(x: 0, y: 0, width: screen.width, height: 40.0))
        _toolbar.doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        _toolbar.cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return _toolbar
    }()
    
    lazy var collectionView: UICollectionView! = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        
        var _collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        _collectionView.showsHorizontalScrollIndicator = false
//        _collectionView.register(DDCContractDetailsCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DDCContractDetailsCollectionViewCell.self))
//        _collectionView.register(DDCTitleTextFieldCell.self, forCellWithReuseIdentifier: String(describing: DDCTitleTextFieldCell.self))
//        _collectionView.register(DDCTextFieldButtonCell.self, forCellWithReuseIdentifier: String(describing: DDCTextFieldButtonCell.self))
//        _collectionView.register(DDCCheckBoxCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DDCCheckBoxCollectionViewCell.self))
//        _collectionView.register(DDCContractHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: DDCContractHeaderFooterView.self))
//        _collectionView.register(DDCSectionHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCSectionHeaderFooterView.self))
//        _collectionView.register(DDCRadioHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCRadioHeaderView.self))
//        _collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: UICollectionReusableView.self))
        
        _collectionView.backgroundColor = UIColor.white
//        _collectionView.delegate = self
//        _collectionView.dataSource = self
        return _collectionView
    }()
    
    lazy var bottomBar: DDCBottomBar = {
        let _bottomBar: DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 10.0, y: 10.0, width: screen.width, height: DDCAppConfig.kBarHeight))
        _bottomBar.addButton(button:DDCBarButton.init(title: "上一步", style: .normal, handler: {
            self.delegate?.previousPage(model: self.model!)
        }))
        _bottomBar.addButton(button:DDCBarButton.init(title: "去付款", style: .forbidden, handler: {
            self.forwardNextPage()
        }))
        return _bottomBar
    }()
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.model?.packageModel = nil
//        self.model?.specs = nil
//        self.model?.contractPrice = nil
//        self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
//        self.contractInfo = DDCContractDetailsViewModelFactory.integrateContractData(model: self.model)
//        self.collectionView.reloadData()
//        self.getPackagesForContract()
//        self.getRelationShopOptions()
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.bottomBar)
        self.setupViewConstraints()
//        self.contractInfo = DDCContractDetailsViewModelFactory.integrateContractData(model: self.model)
    }

}

// MARK: Private
extension DDCContractInfoViewController {
    func configureInputView(textField: UITextField, indexPath: IndexPath) {
        switch indexPath.section {
        case DDCContractTextFieldType.package.rawValue,
             DDCContractTextFieldType.spec.rawValue,
             DDCContractTextFieldType.rule.rawValue:
            do {
                textField.inputAssistantItem.leadingBarButtonGroups = []
                textField.inputAssistantItem.trailingBarButtonGroups = []
                textField.inputView = self.pickerView
                textField.inputAccessoryView = self.toolbar
            }
            break
        case DDCContractTextFieldType.startDate.rawValue :
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

    @objc func setupViewConstraints() {
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

//// MARK: API
//extension DDCContractInfoViewController {
//
//    func getPackagesForContract() {
//        DDCTools.showHUD(view: self.view)
//        DDCContractOptionsAPIManager.packagesForContract(storeId: self.model!.currentStore!.id!,type: (self.model?.contractType)!, successHandler: { (array) in
//            DDCTools.hideHUD()
//            if (array?.count)! > 0 {
//                self.package = array!
//                self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
//            }
//        }) { (error) in
//            DDCTools.hideHUD()
//        }
//    }
//
//    func getCustomCourse() {
//        DDCTools.showHUD(view: self.view)
//        DDCContractOptionsAPIManager.getCustomCourse(storeId: self.model!.currentStore!.id!, successHandler: { (array) in
//            DDCTools.hideHUD()
//            if let models = array {
//                self.customItems = models
//                self.resignFirstResponder()
//                self.collectionView.reloadData()
//            }
//        }) { (error) in
//            DDCTools.hideHUD()
//        }
//    }
//
//    func getCourseSpec() {
//        guard self.pickedPackage != nil else {
//            return
//        }
//        DDCTools.showHUD(view: self.view)
//        DDCContractOptionsAPIManager.getCourseSpec(packageId: (self.pickedPackage?.id)! , successHandler: { (array) in
//            DDCTools.hideHUD()
//            if let models = array {
//                self.specs = models
//            }
//        }) { (error) in
//            DDCTools.hideHUD()
//        }
//    }
//
//    func getRelationShopOptions() {
//        DDCStoreOptionsAPIManager.getRelationShopOptions(currentStoreId: (self.model?.currentStore?.id)!, successHandler: { (stores) in
//            self.model?.relationShops = stores
//            self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
//            self.collectionView.reloadSections([self.models.count - 1])
//        }) { (error) in
//
//        }
//    }
//}
//
// MARK: PickerView
extension DDCContractInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch self.currentTextField?.tag {
        case DDCContractTextFieldType.package.rawValue:
            return self.package.count
        case DDCContractTextFieldType.spec.rawValue:
            do {
                guard self.pickedPackage != nil else {
                    return 1
                }
                return self.specs.count
            }
        case DDCContractTextFieldType.rule.rawValue:
            return self.orderRule.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch self.currentTextField?.tag {
        case DDCContractTextFieldType.package.rawValue:
            return self.package[row].name
        case DDCContractTextFieldType.spec.rawValue:
            do {
                guard self.pickedPackage != nil else {
                    return "请先选择套餐"
                }
                return self.specs[row].name ?? ""
            }
        case DDCContractTextFieldType.rule.rawValue:
            return (self.orderRule[row] as! String)
        default:
            return ""
        }
    }

}
//
//// MARK: Textfield
//extension DDCContractInfoViewController: UITextFieldDelegate {
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        if (textField.tag == DDCContractTextFieldType.money.rawValue && self.pickedPackage != nil && !self.isPickedCustom && !self.modifySkuPrice) {
//            self.view.makeDDCToast(message: "该套餐不能修改价格", image: UIImage.init(named: "addCar_icon_fail")!)
//            return false
//        }
//        return true
//    }
//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        self.currentTextField = textField
//        self.pickerView.reloadAllComponents()
//        if textField.tag == DDCContractTextFieldType.contraceNumber.rawValue ||  (textField.tag == DDCContractTextFieldType.money.rawValue && self.pickedPackage != nil && !self.isPickedCustom && !self.modifySkuPrice) || textField.tag == DDCContractTextFieldType.endDate.rawValue || textField.tag == DDCContractTextFieldType.effectiveDate.rawValue || textField.tag == DDCContractTextFieldType.store.rawValue {
//            return false
//        }
//        if (textField.tag == DDCContractTextFieldType.startDate.rawValue && self.pickedPackage == nil) {
//            self.view.makeDDCToast(message: "请选择套餐", image: UIImage.init(named: "addCar_icon_fail")!)
//            return false
//        }
//        //        if textField.tag == DDCContractTextFieldType.rule.rawValue {
//        ////            self.pickerView.selectRow(self.orderRule.index(of: textField.text as Any), inComponent: 0, animated: true)
//        //        }
//        return true
//    }
//
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if textField.tag == DDCContractTextFieldType.money.rawValue {
//            let text: String = textField.text ?? ""
//            if let price = Double(text) {
//                self.model!.contractPrice = price
//                self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
//                self.collectionView.reloadData()
//                self.formFilled()
//            }
//        }
//        return true
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField.tag == DDCContractTextFieldType.money.rawValue {
//            let text: String = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String
//            //only number
//            if (Double(text) == nil && text.count > 0) {//允许删除唯一一个字符
//                return false
//            } else {
//                return true
//            }
//        }
//        return true
//    }
//
//}
//
// MARK: Action
extension DDCContractInfoViewController {
    
    @objc func forwardNextPage() {
    }

    @objc func done() {
        self.resignFirstResponder()
    }
    
    @objc func cancel() {
        self.resignFirstResponder()
    }

//    @objc func scanAction(_ sender: AnyObject) {
//        self.qrCodeReader.delegate = self
//
//        guard DDCTools.isRightCamera() else {
//            self.openSystemSettingPhoto()
//            return
//        }
//
//        self.qrCodeReader.completionBlock = { (result: QRCodeReaderResult?) in
//            if DDCTools.isQualifiedCode(qrCode: result?.value) {
//                self.models[DDCContractTextFieldType.contraceNumber.rawValue].placeholder = result?.value
//                self.models[DDCContractTextFieldType.contraceNumber.rawValue].isFill = true
//                self.model?.code = result?.value
//                self.collectionView.reloadSections([1])
//                self.formFilled()
//            } else {
//                self.view.makeDDCToast(message:"二维码错误", image: UIImage.init(named: "addCar_icon_fail")!)
//            }
//        }
//
//        // Presents the readerVC as modal form sheet
//        self.qrCodeReader.modalPresentationStyle = .overFullScreen
//        present(self.qrCodeReader, animated: true, completion: nil)
//    }
//
//    func openSystemSettingPhoto() {
//
//        let alertController: UIAlertController = UIAlertController.init(title: "未获得权限访问您的照片", message: "请在设置选项中允许'课程管家'访问您的照片", preferredStyle: .alert)
//        alertController.addAction(UIAlertAction.init(title: "去设置", style: .default, handler: { (action) in
//            let url=URL.init(string: UIApplication.openSettingsURLString)
//            if  UIApplication.shared.canOpenURL(url!){
//                UIApplication.shared.openURL(url!)
//            }
//        }))
//        alertController.addAction(UIAlertAction.init(title: "取消", style: .default, handler: nil))
//        self.present(alertController, animated: true, completion: nil)
//    }
}

//// MARK: - QRCodeReaderViewController Delegate
//extension DDCContractInfoViewController: QRCodeReaderViewControllerDelegate {
//    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
//        reader.stopScanning()
//
//        dismiss(animated: true, completion: nil)
//    }
//
//    func readerDidCancel(_ reader: QRCodeReaderViewController) {
//        reader.stopScanning()
//
//        dismiss(animated: true, completion: nil)
//    }
//}
//
//extension DDCContractInfoViewController: DDCCheckBoxCellControlDelegate {
//    func cellControl(_ control: DDCCheckBoxCellControl, didFinishEdited count: Int, isFilled: Bool) {
//        var pickedSpec: Bool = false
//        self.checkBoxFilled = false
//        for idx in 0..<self.customItems.count {
//            let item: DDCCourseModel = self.customItems[idx]
//            if item.isSelected {
//                pickedSpec = true
//            }
//        }
//        if pickedSpec && isFilled {
//            self.checkBoxFilled = true
//        }
//        if self.checkBoxFilled {
//            self.model?.customItems =  self.reorganizeCustomData()
//        }
//        self.formFilled()
//    }
//
//    func cellControl(_ control: DDCCheckBoxCellControl, didSelectItemAt indexPath: IndexPath) {
//        if self.customItems.count > 0 && indexPath.section == 3 {
//            let items = self.customItems
//            let model = items[indexPath.item]
//            model.isSelected = !model.isSelected
//            self.formFilled()
//        }
//        self.collectionView.reloadData()
//    }
//
//    func formFilled() {
//        if  self.checkBoxFilled && (self.model?.contractPrice != nil || self.model?.specs?.costPrice != nil) &&  self.isCodeFilled {
//            self.bottomBar.buttonArray![1].isEnabled = true
//            self.bottomBar.buttonArray![1].setStyle(style: .highlighted)
//        } else {
//            self.bottomBar.buttonArray![1].isEnabled = false
//            self.bottomBar.buttonArray![1].setStyle(style: .forbidden)
//        }
//    }
//
//    func reorganizeCustomData() -> [DDCCourseModel]{
//        var selectedItems: [DDCCourseModel] = Array()
//        var totalcount: Int = 0
//        let customItems: [DDCCourseModel] = self.customItems.map{($0.copy() as! DDCCourseModel) }
//
//        for item in customItems {
//            if item.isSelected == true {
//                var attributes: [DDCCourseAttributeModel] = Array()
//                if let _attributes = item.attributes {//有子产品
//                    for att in _attributes {
//                        if att.isSelected == true {
//                            totalcount += att.totalCount
//                            attributes.append(att)
//                        }
//                    }
//                    item.attributes = attributes
//                } else {
//                    totalcount += item.totalCount
//                }
//                selectedItems.append(item)
//            }
//        }
//        if selectedItems.count > 0 {
//            let calendar: Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
//            var components: DateComponents = DateComponents.init()
//            let validPeriod: Int = totalcount <= 48 ? totalcount : 48
//            components.setValue(validPeriod, for: .month)
//            let maxDate: Date = calendar.date(byAdding: components, to: DDCTools.datetime(from: self.model?.packageModel?.startUseTime))!
//            self.model!.packageModel!.endEffectiveTime = DDCTools.dateToTimeInterval(from: maxDate)
//            let spec: DDCContractPackageCategoryModel = DDCContractPackageCategoryModel()
//            spec.validPeriod = validPeriod
//            self.model!.specs = spec
//            self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
//            self.models[DDCContractTextFieldType.spec.rawValue].isFill = true
//            self.collectionView.reloadData()
//        }
//        return selectedItems
//    }
//}
