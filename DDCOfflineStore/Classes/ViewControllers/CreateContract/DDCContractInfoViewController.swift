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

    var orderRule: NSArray = ["跳过","遵守"]
    var models: [DDCContractInfoViewModel] = Array()
    var contractInfo: [DDCContractDetailsViewModel] = Array()

    var currentTextField: UITextField?
    var items: [DDCCourseModel] = Array()
    var package: [DDCContractPackageModel] = Array()
    var specs: [DDCContractPackageCategoryModel] = Array()

    var checkBoxControls: [DDCCheckBoxCellControl] = Array()
    var pickedPackage: DDCContractPackageModel?
    var isPickedCustom: Bool = false

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
//        _pickerView.delegate = self
//        _pickerView.dataSource = self
        return _pickerView
    }()

    private lazy var toolbar: DDCToolbar = {
        let _toolbar = DDCToolbar.init(frame: CGRect.init(x: 0, y: 0, width: screen.width, height: 40.0))
//        _toolbar.doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
//        _toolbar.cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return _toolbar
    }()

    private lazy var bottomBar: DDCBottomBar = {
        let _bottomBar: DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 10.0, y: 10.0, width: 10.0, height: 10.0))
        _bottomBar.addButton(button:DDCBarButton.init(title: "上一步", style: .normal, handler: {
            self.delegate?.previousPage(model: self.model!)
        }))
        _bottomBar.addButton(button:DDCBarButton.init(title: "下一步", style: .forbidden, handler: {
//            self.forwardNextPage()
        }))
        return _bottomBar
    }()

    lazy var collectionView: UICollectionView! = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        var _collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        _collectionView.showsHorizontalScrollIndicator = false
        _collectionView.backgroundColor = UIColor.white
        return _collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.bottomBar)
        self.setupViewConstraints()
        self.contractInfo = DDCContractDetailsViewModelFactory.integrateContractData(model: self.model)
//        self.models = DDCAddContractInfoModelFactory.integrateData(model: self.model, type:self.model!.courseType)
    }
}

// MARK: Private
extension DDCContractInfoViewController {
    
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

// MARK: API
extension DDCContractInfoViewController {
    
    func getPackagesForContract() {
        DDCTools.showHUD(view: self.view)
        DDCContractOptionsAPIManager.packagesForContract(storeId: self.model!.currentStore!.id!, type: (self.model?.contractType)!, successHandler: { (array) in
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
                self.items = models
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
//            self.collectionView.reloadSections([self.models.count - 1])
        }) { (error) in
            
        }
    }
    
    func getGroupCourse() {
        DDCTools.showHUD(view: self.view)
        DDCContractOptionsAPIManager.getGroupCourse(storeId: 4, successHandler: { (tuple) in
            DDCTools.hideHUD()
//            self.groupItems = tuple
//            self.collectionView.reloadData()
        }) { (error) in
            DDCTools.hideHUD()
        }
    }
}


// MARK: Textfield
extension DDCContractInfoViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.currentTextField = textField
        if textField.tag == DDCContractTextFieldType.contraceNumber.rawValue ||  (textField.tag == DDCContractTextFieldType.money.rawValue && self.pickedPackage != nil) || textField.tag == DDCContractTextFieldType.endDate.rawValue || textField.tag == DDCContractTextFieldType.effectiveDate.rawValue || textField.tag == DDCContractTextFieldType.store.rawValue{
            return false
        }
        if textField.tag == DDCContractTextFieldType.rule.rawValue {
            self.pickerView.selectRow(self.orderRule.index(of: textField.text as Any), inComponent: 0, animated: true)
        }
        return true
    }
}


// MARK: Action
extension DDCContractInfoViewController {
    @objc func done() {
    }
    
    @objc func cancel() {
        self.resignFirstResponder()
    }
    
    func forwardNextPage() {
        //        self.bottomBar.buttonArray![1].isEnabled = false
        
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
        DDCCreateContractAPIManager.saveContract(model: self.model!, successHandler: { (model) in
            DDCTools.hideHUD()
            self.delegate?.nextPage(model: self.model!)
        }) { (error) in
            DDCTools.hideHUD()
        }
        
    }
    
    @objc func scanAction(_ sender: AnyObject) {
        self.qrCodeReader.delegate = self
        
        self.qrCodeReader.completionBlock = { (result: QRCodeReaderResult?) in
            self.models[DDCContractTextFieldType.contraceNumber.rawValue].text = result?.value
            self.models[DDCContractTextFieldType.contraceNumber.rawValue].isFill = true
            self.model?.code = result?.value
//            self.collectionView.reloadSections([1])
        }
        
        // Presents the readerVC as modal form sheet
        self.qrCodeReader.modalPresentationStyle = .overFullScreen
        present(self.qrCodeReader, animated: true, completion: nil)
    }
    
}

// MARK: - QRCodeReaderViewController Delegate
extension DDCContractInfoViewController: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()

        dismiss(animated: true, completion: nil)
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()

        dismiss(animated: true, completion: nil)
    }
}
