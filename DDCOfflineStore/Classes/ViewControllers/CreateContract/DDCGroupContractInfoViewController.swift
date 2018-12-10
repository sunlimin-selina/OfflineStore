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

class DDCGroupContractInfoViewController: DDCContractInfoViewController {
    
    var groupItems: (customCourses: [DDCCourseModel]?, sampleCourses: [DDCCourseModel]?)?
    var groupCourses: [DDCCheckBoxModel] = [DDCCheckBoxModel.init(id: nil, title: "购买正式课程", discription: "", isSelected: false) ,DDCCheckBoxModel.init(id: nil, title: "购买体验课程", discription: "", isSelected: false)]
    var pickedSection: Int = 999
    
    var customCoursesControls: [DDCCheckBoxCellControl] = Array()
    
    var isPickedPackage: Bool = false
    var checkBoxFilled: Bool = false
    var upgradeLimit: Int = 0

    lazy var qrCodeReader: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        self.model?.contractPrice = nil
        self.contractInfo = DDCContractDetailsViewModelFactory.integrateContractData(model: self.model)
        self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.contractInfo = DDCContractDetailsViewModelFactory.integrateContractData(model: self.model)
        self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
        self.getGroupCourse()
        self.getRelationShopOptions()
    }
}

// MARK: Private
extension DDCGroupContractInfoViewController {
    func setupCollectionView(){
        
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
                var height: CGFloat = 45
                let customModel: DDCCourseModel = (self.groupItems?.customCourses![indexPath.item])!
                if customModel != nil && customModel.attributes != nil{
                    height = CGFloat((customModel.isSelected ? (customModel.attributes?.count)! + 1: 1 ) * 42)
                }
                return CGSize.init(width: DDCAppConfig.width, height: height)
            }
            return CGSize.zero
        } else if indexPath.section == 3 {
            if indexPath.section ==  (self.pickedSection + 2)  {
                return CGSize.init(width: screen.width, height: 45)
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
            let identifier = "\(String(describing: DDCCheckBoxCollectionViewCell.self))\(indexPath.section)\(indexPath.item)"
            collectionView.register(DDCCheckBoxCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! DDCCheckBoxCollectionViewCell
            cell.tag = indexPath.item
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
            let identifier = "\(String(describing: DDCCheckBoxCollectionViewCell.self))\(indexPath.section)\(indexPath.item)"
            collectionView.register(DDCCheckBoxCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! DDCCheckBoxCollectionViewCell
            cell.tag = indexPath.item
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

// MARK: Textfield
extension DDCGroupContractInfoViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.currentTextField = textField
        self.pickerView.reloadAllComponents()
        if textField.tag == DDCContractTextFieldType.contraceNumber.rawValue || textField.tag == DDCContractTextFieldType.endDate.rawValue || textField.tag == DDCContractTextFieldType.effectiveDate.rawValue || textField.tag == DDCContractTextFieldType.store.rawValue || textField.tag == DDCContractTextFieldType.rule.rawValue {
            return false
        }
        if (textField.tag == DDCContractTextFieldType.startDate.rawValue && self.model?.packageModel == nil) {
            self.view.makeDDCToast(message: "请选择套餐", image: UIImage.init(named: "addCar_icon_fail")!)
            return false
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
}

// MARK: Action
extension DDCGroupContractInfoViewController {
    override func forwardNextPage() {
        super.forwardNextPage()
        self.bottomBar.buttonArray![1].isEnabled = false
        
        if self.model?.contractType == .groupRegular {
           self.model?.customItems = self.wrapItems(models: (self.groupItems?.customCourses)!)
        } else {
            self.model?.customItems = self.wrapItems(models: (self.groupItems?.sampleCourses)!)
        }
        self.models[DDCContractTextFieldType.rule.rawValue].isFill = true

        for index in 1..<self.models.count {
            let model: DDCContractInfoViewModel = self.models[index]
            if self.model?.code != nil , index == 1 {
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
            self.delegate?.nextPage(model: self.model!)
        }) { (error) in
            DDCTools.hideHUD()
            self.bottomBar.buttonArray![1].isEnabled = true
            self.view.makeDDCToast(message: error, image: UIImage.init(named: "addCar_icon_fail")!)
        }
    }
    
    @objc override func done() {
        let section = self.currentTextField?.tag
        switch section {
        case DDCContractTextFieldType.startDate.rawValue:
            do {
                let dateFormatter: DateFormatter = DateFormatter.init(withFormat: "YYYY/MM/dd", locale: "")
                let startDate: Date = self.datePickerView.date
                self.model?.packageModel?.startUseTime = DDCTools.dateToTimeInterval(from: startDate)
                if self.model?.specs != nil {
                    let calendar: Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
                    var components: DateComponents = DateComponents.init()
                    components.setValue(self.model?.specs?.validPeriod, for: .month)
                    let maxDate: Date = calendar.date(byAdding: components, to: startDate)!
                    self.model!.packageModel!.endEffectiveTime = DDCTools.dateToTimeInterval(from: maxDate)
                    self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
                }
                self.collectionView.reloadData()
            }
        default:
            return
        }
        self.collectionView.reloadData()
        self.resignFirstResponder()
    }
    
    @objc override func cancel() {
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
        self.model!.contractPrice = nil
        if self.checkBoxFilled {
            if  let customCourses = self.groupItems?.customCourses ,
                self.model?.contractType == .groupRegular {
                self.model?.customItems =  self.wrapItems(models: customCourses)
            } else if let sampleCourses = self.groupItems?.sampleCourses ,
                self.model?.contractType == .groupSample {
                self.model?.customItems =  self.wrapItems(models: sampleCourses)
            }
        }
        self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
        self.collectionView.reloadData()
    }
    
    @objc func scanAction(_ sender: AnyObject) {
        self.qrCodeReader.delegate = self
        
        self.qrCodeReader.completionBlock = { (result: QRCodeReaderResult?) in
            if DDCTools.isQualifiedCode(qrCode: (result?.value)!) {
                self.models[DDCContractTextFieldType.contraceNumber.rawValue].placeholder = result?.value
                self.models[DDCContractTextFieldType.contraceNumber.rawValue].isFill = true
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
        var pickedSpec: Bool = false
        self.checkBoxFilled = false
        if  let customCourses = self.groupItems?.customCourses ,
            self.model?.contractType == .groupRegular {
            for idx in 0..<customCourses.count {
                let item: DDCCourseModel = customCourses[idx]
                if item.isSelected {
                    pickedSpec = true
                }
            }
        } else if let sampleCourses = self.groupItems?.sampleCourses ,
            self.model?.contractType == .groupSample{
            for idx in 0..<sampleCourses.count {
                let item: DDCCourseModel = sampleCourses[idx]
                if item.isSelected {
                    pickedSpec = true
                }
            }
        }
       
        if pickedSpec && isFilled {
            self.checkBoxFilled = true
        }
        if self.checkBoxFilled {
            if  let customCourses = self.groupItems?.customCourses ,
                self.model?.contractType == .groupRegular {
                self.model?.customItems =  self.wrapItems(models: customCourses)
            } else if let sampleCourses = self.groupItems?.sampleCourses ,
                self.model?.contractType == .groupSample {
                self.model?.customItems =  self.wrapItems(models: sampleCourses)
            }
        }
        self.formFilled()
    }
    
    func cellControl(_ control: DDCCheckBoxCellControl, didSelectItemAt indexPath: IndexPath) {
        if (self.groupItems?.sampleCourses!.count)! > 0 && indexPath.section == 3 {
            let items = self.groupItems?.sampleCourses
            let model = items![indexPath.item]
            model.isSelected = !model.isSelected
            self.formFilled()
        } else {
            if (self.groupItems?.customCourses!.count)! > 0 {
                let items = self.groupItems?.customCourses!
                let model = items![indexPath.item]
                model.isSelected = !model.isSelected
            }
        }
        self.collectionView.reloadData()
    }
    
    func formFilled() {
        if self.checkBoxFilled && (self.model?.contractPrice != nil || self.model?.specs?.costPrice != nil) && self.model?.code != nil{
            self.bottomBar.buttonArray![1].isEnabled = true
            self.bottomBar.buttonArray![1].setStyle(style: .highlighted)
        } else {
            self.bottomBar.buttonArray![1].isEnabled = false
            self.bottomBar.buttonArray![1].setStyle(style: .forbidden)
        }
    }
    
    func wrapItems(models: [DDCCourseModel]) -> [DDCCourseModel]{
        var selectedItems: [DDCCourseModel] = Array()
        var totalcount: Int = 0
        let customItems: [DDCCourseModel] = models.map{($0.copy() as! DDCCourseModel) }

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
            let calendar: Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
            var components: DateComponents = DateComponents.init()
            let validPeriod: Int = totalcount <= 48 ? totalcount : 48
            components.setValue(validPeriod, for: .month)
            let packageModel: DDCContractPackageModel = DDCContractPackageModel()
            let startTime: CLong = model?.packageModel?.startUseTime != nil ? (model?.packageModel?.startUseTime)! : DDCTools.dateToTimeInterval(from: Date())
            let maxDate: Date = calendar.date(byAdding: components, to: DDCTools.datetime(from: startTime))!
            packageModel.endEffectiveTime = DDCTools.dateToTimeInterval(from: maxDate)
            packageModel.startUseTime = startTime
            packageModel.packageType = .limited
            packageModel.upgradeLimit = self.upgradeLimit//限制跳过
            if self.model?.contractType == .groupRegular{
                packageModel.packageType = .category
            }
            self.model?.packageModel = packageModel
            let spec: DDCContractPackageCategoryModel = DDCContractPackageCategoryModel()
            spec.validPeriod = validPeriod
            self.model!.specs = spec
            self.models[DDCContractTextFieldType.spec.rawValue].isFill = true
            self.models[DDCContractTextFieldType.package.rawValue].isFill = true
            self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
            self.collectionView.reloadData()

        }
        return selectedItems
    }
}
