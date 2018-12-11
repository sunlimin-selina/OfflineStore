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

    var model: DDCContractModel? {
        get {
            return _model
        }
    }

    lazy var qrCodeReader: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        return QRCodeReaderViewController(builder: builder)
    }()

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
        _collectionView.backgroundColor = UIColor.white
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.bottomBar)
        self.setupViewConstraints()
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

// MARK: API
extension DDCContractInfoViewController {

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


// MARK: Action
extension DDCContractInfoViewController {
    @objc func formFilled() {
    }
    
    @objc func forwardNextPage() {
    }

    @objc func done() {
        self.resignFirstResponder()
    }
    
    @objc func cancel() {
        self.resignFirstResponder()
    }

    @objc func scanAction(_ sender: AnyObject) {
        self.qrCodeReader.delegate = self

        guard DDCTools.isRightCamera() else {
            self.openSystemSettingPhoto()
            return
        }

        self.qrCodeReader.completionBlock = { (result: QRCodeReaderResult?) in
            if DDCTools.isQualifiedCode(qrCode: result?.value) {
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

    func openSystemSettingPhoto() {

        let alertController: UIAlertController = UIAlertController.init(title: "未获得权限访问您的照片", message: "请在设置选项中允许'课程管家'访问您的照片", preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "去设置", style: .default, handler: { (action) in
            let url=URL.init(string: UIApplication.openSettingsURLString)
            if  UIApplication.shared.canOpenURL(url!){
                UIApplication.shared.openURL(url!)
            }
        }))
        alertController.addAction(UIAlertAction.init(title: "取消", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
