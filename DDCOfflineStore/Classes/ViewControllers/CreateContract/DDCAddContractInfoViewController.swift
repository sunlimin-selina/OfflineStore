//
//  DDCAddContractInfoViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCAddContractInfoViewController: DDCChildContractViewController {
    var contractInfo: [DDCContractDetailsViewModel] = DDCContractDetailsViewModelFactory.integrateContractData(category: nil)
    var models: [DDCContractInfoViewModel] = DDCAddContractInfoModelFactory.integrateData(model:  DDCCustomerModel(), channels: [DDCChannelModel()])
    var currentTextField: UITextField?
    var items: [DDCCourseModel] = Array()
    var checkBoxControls: [DDCCheckBoxCellControl] = Array()

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
        _collectionView.register(DDCContractHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: DDCContractHeaderFooterView.self))
        _collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: UICollectionReusableView.self))

        _collectionView.backgroundColor = UIColor.white
        _collectionView.delegate = self
        _collectionView.dataSource = self
        return _collectionView
    }()
    
    private lazy var bottomBar: DDCBottomBar = {
        let _bottomBar : DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 10.0, y: 10.0, width: 10.0, height: 10.0))
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
        self.getPackagesForContract()
    }
    
}

// MARK: Private
extension DDCAddContractInfoViewController {
    func configureInputView(textField: UITextField, indexPath: IndexPath) {
        textField.inputAssistantItem.leadingBarButtonGroups = []
        textField.inputAssistantItem.trailingBarButtonGroups = []
        textField.inputView = self.pickerView
        textField.inputAccessoryView = self.toolbar
//        switch indexPath.row {
//        case DDCClientTextFieldType.channel.rawValue, DDCClientTextFieldType.career.rawValue, DDCClientTextFieldType.sex.rawValue,DDCClientTextFieldType.memberReferral.rawValue:
//            do {
//
//            }
//            break
//        case DDCClientTextFieldType.birthday.rawValue:
//            do {
//                textField.inputAssistantItem.leadingBarButtonGroups = []
//                textField.inputAssistantItem.trailingBarButtonGroups = []
//                textField.inputView = self.datePickerView
//                textField.inputAccessoryView = self.toolbar
//            }
//            break
//        case DDCClientTextFieldType.email.rawValue:
//            do {
//                textField.inputView = nil
//                textField.inputAccessoryView = nil
//                textField.keyboardType = .emailAddress
//            }
//            break
//        case DDCClientTextFieldType.channelDetail.rawValue:
//            do {
//                textField.inputView = nil
//                textField.inputAccessoryView = nil
//                textField.keyboardType = .default
//            }
//            break
//        default:
//            do {
//                textField.inputView = nil
//                textField.inputAccessoryView = nil
//                textField.keyboardType = .phonePad
//            }
//            break
//        }
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
        return self.models.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.contractInfo.count
        } else if self.items.count > 0 && section == 3 {
            return self.items.count
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
        } else if self.items.count > 0 && indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCCheckBoxCollectionViewCell.self), for: indexPath) as! DDCCheckBoxCollectionViewCell
            let model: DDCCourseModel = self.items[indexPath.item]
            let control = DDCCheckBoxCellControl.init(cell: cell)
            control.configureCell(model: model, indexPath: indexPath)
            self.checkBoxControls.insert(control, at: indexPath.item)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCTitleTextFieldCell.self), for: indexPath) as! DDCTitleTextFieldCell
            let model: DDCContractInfoViewModel = self.models[indexPath.section - 1]
            cell.configureCell(model: model, indexPath: indexPath, showHint: false)
            self.configureInputView(textField: cell.textFieldView.textField, indexPath: indexPath)
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
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: UICollectionReusableView.self), for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize.init(width: 500, height: 20)
        }  else if self.items.count > 0 && indexPath.section == 3 {
            return CGSize.init(width: 500, height: self.checkBoxControls.count > 0 ?self.checkBoxControls[indexPath.item].cellHeight() : 30)
        }
        return CGSize.init(width: 500, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let top: CGFloat = (section == 0 || section == 3 ) ? 0 : 20
        let bottom: CGFloat = (section == 0 || section == 3 ) ? 0 : 25
        return UIEdgeInsets.init(top: top, left: (screen.width - 500)/2, bottom: bottom, right: (screen.width - 500)/2)
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
            return CGSize.init(width: 500, height: 70.0)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
}

extension DDCAddContractInfoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.items.count > 0 && indexPath.section == 3 {
            let items = self.items
            
            var model = items[indexPath.item]
            model.isSelected = !model.isSelected
        }
        self.collectionView.reloadSections([indexPath.section])
    }
    
}

// MARK: API
extension DDCAddContractInfoViewController {
    
    func getPackagesForContract() {
        DDCTools.showHUD(view: self.view)//(self.model?.currentStore?.id)!
        DDCContractOptionsAPIManager.packagesForContract(storeId: 4, successHandler: { (array) in
            DDCTools.hideHUD()
//            self.items = Array
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
}

// MARK: PickerView
extension DDCAddContractInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        switch self.currentTextField?.tag {
//        case DDCClientTextFieldType.sex.rawValue:
//            return DDCContract.genderArray.count
//        case DDCClientTextFieldType.career.rawValue:
//            return DDCContract.occupationArray.count
//        case DDCClientTextFieldType.channel.rawValue:
//            return (self.channels?.count)!
//        case DDCClientTextFieldType.memberReferral.rawValue:
//            return 2
//        default:
            return 0
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        switch self.currentTextField?.tag {
//        case DDCClientTextFieldType.sex.rawValue:
//            return DDCContract.genderArray[row]
//        case DDCClientTextFieldType.career.rawValue:
//            return DDCContract.occupationArray[row]
//        case DDCClientTextFieldType.channel.rawValue:
//            return (self.channels?.count != 0) ? (self.channels?[row] )!.name : "加载中"
//        case DDCClientTextFieldType.memberReferral.rawValue:
//            return memberReferral[row]
//        default:
            return ""
//        }
    }
    
}

// MARK: Textfield
extension DDCAddContractInfoViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.currentTextField = textField
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //限制字符长度
        let existedLength: Int = (textField.text?.count)!
        let selectedLength: Int = range.length
        let replaceLength: Int = string.count
        let totalLength: Int = existedLength - selectedLength + replaceLength
        
//        if textField.tag == DDCClientTextFieldType.phone.rawValue || textField.tag == DDCClientTextFieldType.memberPhone.rawValue {
//            if (totalLength > 13) {//手机号输入长度不超过11个字符 多两个字符为分割号码用的空格
//                return false
//            }
//            textField.text = DDCTools.splitPhoneNumber(string: textField.text!, length: totalLength)
//        } else if textField.tag == DDCClientTextFieldType.channelDetail.rawValue {
//            if (totalLength > 20) {//渠道详情不超过20字
//                return false
//            }
//        } else if textField.tag == DDCClientTextFieldType.memberName.rawValue || textField.tag == DDCClientTextFieldType.sales.rawValue{
//            return false
//        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        let rawValue: Int = textField.tag
//        
//        if rawValue == DDCClientTextFieldType.phone.rawValue || rawValue == DDCClientTextFieldType.name.rawValue ||
//            rawValue == DDCClientTextFieldType.age.rawValue ||
//            rawValue == DDCClientTextFieldType.email.rawValue ||
//            rawValue == DDCClientTextFieldType.channelDetail.rawValue || rawValue == DDCClientTextFieldType.memberPhone.rawValue || rawValue == DDCClientTextFieldType.memberName.rawValue {
//            self.models[rawValue].text = textField.text
//            self.models[rawValue].isFill = true
//        }
        return true
    }
}

// MARK: Action
extension DDCAddContractInfoViewController {
    @objc func done() {
//        switch self.currentTextField?.tag {
//        case DDCClientTextFieldType.birthday.rawValue:
//            do {
//                let dateFormatter: DateFormatter = DateFormatter.init(withFormat: "YYYY/MM/dd", locale: "")
//                let birthday: Date = self.datePickerView.date
//                self.models[DDCClientTextFieldType.birthday.rawValue].text = dateFormatter.string(from: birthday)
//                let components = Calendar.current.dateComponents([.year], from: birthday, to: Date())
//                self.models[DDCClientTextFieldType.age.rawValue].text = "\(components.year ?? 0)"
//                self.models[DDCClientTextFieldType.age.rawValue].isFill = true
//            }
//            break
//        case DDCClientTextFieldType.sex.rawValue:
//            self.models[DDCClientTextFieldType.sex.rawValue].text = DDCContract.genderArray[self.pickerView.selectedRow(inComponent: 0)]
//            self.models[DDCClientTextFieldType.sex.rawValue].isFill = true
//            break
//        case DDCClientTextFieldType.career.rawValue:
//            self.models[DDCClientTextFieldType.career.rawValue].text = DDCContract.occupationArray[self.pickerView.selectedRow(inComponent: 0)]
//            self.models[DDCClientTextFieldType.career.rawValue].isFill = true
//            break
//        case DDCClientTextFieldType.channel.rawValue:
//            self.models[DDCClientTextFieldType.channel.rawValue].text = self.channels![self.pickerView.selectedRow(inComponent: 0)].name
//            self.models[DDCClientTextFieldType.channel.rawValue].isFill = true
//            break
//        case DDCClientTextFieldType.memberReferral.rawValue:
//            do {
//                let isMemberReferral: String = memberReferral[self.pickerView.selectedRow(inComponent: 0)]
//                self.models[DDCClientTextFieldType.memberReferral.rawValue].text = isMemberReferral
//                self.models[DDCClientTextFieldType.memberReferral.rawValue].isFill = true
//                //是否为会员推荐
//                self.models = DDCEditClientInfoModelFactory.reloadData(models: self.models, isReferral: (isMemberReferral == "是") ? true : false)
//                self.collectionView.reloadData()
//            }
//        default:
//            break
//        }
//
        self.getCustomCourse()
        self.collectionView.reloadData()
        self.resignFirstResponder()
    }
    
    @objc func cancel() {
        self.collectionView.reloadData()
        self.resignFirstResponder()
    }
}
