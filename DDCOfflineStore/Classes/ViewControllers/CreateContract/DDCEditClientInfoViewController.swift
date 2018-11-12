//
//  DDCEditClientInfoViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/15.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCEditClientInfoViewController: DDCChildContractViewController {

    enum DDCClientTextFieldType : Int{
        case phone
        case name
        case sex
        case birthday
        case age
        case email
        case career
        case channel
        case channelDetail
        case memberReferral
        case memberPhone
        case memberName
        case sales
    }
    
    var models: [DDCContractInfoViewModel] = DDCEditClientInfoModelFactory.integrateData(model:  DDCCustomerModel(), channels: [DDCChannelModel()])
    var channels: [DDCChannelModel]? = Array()
    var currentTextField: UITextField?
    var memberReferral = ["是","否"]
    var showHint: Bool = false
    
    private lazy var contentView: UIView = {
        var _contentView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screen.width, height: screen.height))
        _contentView.backgroundColor = UIColor.white
        return _contentView
    }()
    
    private lazy var bottomBar: DDCBottomBar = {
        let _bottomBar : DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 10.0, y: 10.0, width: 10.0, height: 10.0))
        _bottomBar.addButton(button:DDCBarButton.init(title: "下一步", style: .highlighted, handler: {
            self.forwardNextPage()
        }))
        return _bottomBar
    }()
    
    private lazy var toolbar: DDCToolbar = {
        let _toolbar = DDCToolbar.init(frame: CGRect.init(x: 0, y: 0, width: screen.width, height: 40.0))
        _toolbar.doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        _toolbar.cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return _toolbar
    }()
    
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
    
    lazy var collectionView: UICollectionView! = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        var _collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        _collectionView.showsHorizontalScrollIndicator = false
        _collectionView.register(DDCTitleTextFieldCell.self, forCellWithReuseIdentifier: String(describing: DDCTitleTextFieldCell.self))
        _collectionView.backgroundColor = UIColor.white
        _collectionView.delegate = self
        _collectionView.dataSource = self
        return _collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getChannels()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.contentView)
        self.contentView.addSubview(self.collectionView)
        self.contentView.addSubview(self.bottomBar)
        self.setupViewConstraints()
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(keyboardWillShow(notification:)),
            name:UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(keyboardWillHide(notification:)),
            name:UIResponder.keyboardWillHideNotification,
            object: nil)
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureAction))
        self.view.addGestureRecognizer(tapGesture)
    }
}

// MARK: private
extension DDCEditClientInfoViewController {
    private func setupViewConstraints() {
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
    
    func update() {
        let customer: DDCCustomerModel = DDCCustomerModel()
        self.model = DDCContractModel()
        self.model?.customer = customer
        self.model!.customer?.userName = self.models[DDCClientTextFieldType.phone.rawValue].text
        self.model!.customer?.nickName = self.models[DDCClientTextFieldType.name.rawValue].text
        //性别
        let genderArray: NSArray = DDCContract.genderArray as NSArray
        self.model!.customer?.sex = DDCGender(rawValue: genderArray.index(of: self.models[DDCClientTextFieldType.sex.rawValue].text as Any))
        //生日
        if let birthdayText: String = self.models[DDCClientTextFieldType.birthday.rawValue].text!,
            self.models[DDCClientTextFieldType.birthday.rawValue].text!.count > 0{
            let birthday: Int = DDCTools.date(from: birthdayText)
            self.model?.customer?.birthday = birthday
        }
        //年龄
        self.model!.customer?.age = self.models[DDCClientTextFieldType.age.rawValue].text
        //邮箱
        self.model!.customer?.email = self.models[DDCClientTextFieldType.email.rawValue].text
        //职业
        let occupationArray: NSArray = DDCContract.occupationArray as NSArray
        self.model?.customer?.career = String(occupationArray.index(of: self.models[DDCClientTextFieldType.career.rawValue].text as Any))
        //渠道
        if let channels : NSArray = (self.channels! as NSArray) {
            let idx : Int = channels.indexOfObject { (channelModel, idx, stop) -> Bool in
                if let object = channelModel as? DDCChannelModel{
                    return object.name == self.models[DDCClientTextFieldType.channel.rawValue].text
                }
                return false
            }
            if idx != NSNotFound {
                self.model?.customer!.channel = "\(self.channels![idx].name!)"
            }
        }
        
        //渠道详情
        self.model!.customer?.channelDesc = self.models[DDCClientTextFieldType.channelDetail.rawValue].text
        //是否会员介绍
        self.model!.customer?.isReferral = self.models[DDCClientTextFieldType.memberReferral.rawValue].text == "是" ? 0 : 1
        //会员手机号
        self.model!.customer?.memberPhone = self.models[DDCClientTextFieldType.memberPhone.rawValue].text
        //会员姓名
        self.model!.customer?.memberName = self.models[DDCClientTextFieldType.memberName.rawValue].text
        //责任销售
        self.model!.responsibleUsername = self.models[DDCClientTextFieldType.sales.rawValue].text
    }
    
    func forwardNextPage() {
        self.bottomBar.buttonArray![0].isEnabled = false
        var canForward: Bool = true
        
        for index in 0...(self.models.count - 1) {
            canForward = false
            let model: DDCContractInfoViewModel = self.models[index]
            if model.isRequired! ,
                (!model.isFill! && (model.text?.count)! <= 0) {
                self.bottomBar.buttonArray![0].isEnabled = true
                self.showHint = true
                self.view.makeDDCToast(message: "信息填写不完整，请填写完整", image: UIImage.init(named: "addCar_icon_fail")!)
                self.collectionView.reloadData()
                return
            }
            if index == DDCClientTextFieldType.name.rawValue {
                guard DDCTools.validateString(string: model.text!) else {
                    self.view.makeDDCToast(message: "姓名格式不对，只支持中英文，不能有多余的空格", image: UIImage.init(named: "addCar_icon_fail")!)
                    self.collectionView.reloadData()
                    return
                }
            }
            if index == DDCClientTextFieldType.email.rawValue,
                (model.text?.count)! > 0,
                let email = model.text{
                guard DDCTools.validateEmail(email: email) else {
                    self.view.makeDDCToast(message: "邮箱格式不对，请输入准确的邮箱地址", image: UIImage.init(named: "addCar_icon_fail")!)
                    self.collectionView.reloadData()
                    return
                }
            }
        }
        if !canForward {
            self.bottomBar.buttonArray![0].isEnabled = true
            DDCTools.showHUD(view: self.view)
        }
        
        self.update()
        DDCTools.showHUD(view: self.view)
        DDCEditClientInfoAPIManager.uploadUserInfo(model: self.model!, successHandler: { (model) in
            DDCTools.hideHUD()
            
        }) { (error) in
            
        }
        self.delegate?.nextPage(model: self.model!)
    }
    
    func configureCell(cell: DDCTitleTextFieldCell, model : DDCContractInfoViewModel, indexPath: IndexPath, showHint: Bool) {
        var _showHint = showHint
        cell.subtitle.removeFromSuperview()
        cell.textFieldView.textField.isUserInteractionEnabled = true
        cell.textFieldView.textField.clearButtonMode = .always
        cell.textFieldView.type = .normal
        
        if indexPath.item == 0 {
            _showHint = true
            cell.textFieldView.type = .labelButton
            cell.textFieldView.button.setTitle("获取用户信息", for: .normal)
        } else if (indexPath.item == 1 && model.text!.count > 0) {
            cell.textFieldView.type = .labelButton
            cell.subtitle.text = "会员"//model.descriptions
            cell.textFieldView.addSubview(cell.subtitle)
            cell.textFieldView.button.isHidden = true
            cell.subtitle.snp.makeConstraints { (make) in
                make.left.equalTo(cell.textFieldView.textField.snp_rightMargin)
                make.right.top.bottom.equalTo(cell.textFieldView)
                make.width.equalTo(60)
            }
        } else if (indexPath.item == 10 && model.title == "介绍会员电话") {
            cell.textFieldView.type = .labelButton
            cell.textFieldView.button.setTitle("会员验证", for: .normal)
        } else if (indexPath.item == 4) {
            // 不让用户手动改年龄
            cell.textFieldView.textField.isUserInteractionEnabled = false
            cell.textFieldView.textField.clearButtonMode = .never
        } else if (indexPath.item == 11 && model.title == "介绍会员姓名") || (indexPath.item == 12) || (indexPath.item == 10 && model.title == "责任销售") {
            cell.textFieldView.textField.isUserInteractionEnabled = false
            cell.textFieldView.textField.clearButtonMode = .never
        }
        else {
            cell.textFieldView.type = .normal
        }
        cell.titleLabel.configure(title: model.title ?? "", isRequired: model.isRequired!, tips: model.tips!, isShowTips:_showHint)
        cell.textFieldView.textField.attributedPlaceholder = NSAttributedString.init(string:model.placeholder!, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18.0)])
        cell.textFieldView.textField.text = model.text
        cell.textFieldView.textField.tag = indexPath.row
        cell.textFieldView.textField.delegate = self
        cell.textFieldView.button.addTarget(self, action: #selector(getVerificationCode(button:)), for: .touchUpInside)
    }
    
}

// MARK: UICollectionViewDelegate
extension DDCEditClientInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCTitleTextFieldCell.self), for: indexPath) as! DDCTitleTextFieldCell
        let model: DDCContractInfoViewModel = self.models[indexPath.item]
        self.configureCell(cell: cell, model: model, indexPath: indexPath, showHint: self.showHint)
        self.configureInputView(textField: cell.textFieldView.textField, indexPath: indexPath)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == DDCClientTextFieldType.name.rawValue ||
            indexPath.item == DDCClientTextFieldType.birthday.rawValue
        {
            return CGSize.init(width: 320, height: 90)
        } else if  indexPath.item == DDCClientTextFieldType.age.rawValue || indexPath.item == DDCClientTextFieldType.sex.rawValue{
            return CGSize.init(width: 120, height: 90)
        } else {
            return CGSize.init(width: 500, height: 90)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: (screen.width - 500)/2, bottom: 0, right: (screen.width - 500)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 60.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50.0
    }
    
}

// MARK: Private
extension DDCEditClientInfoViewController {
    func configureInputView(textField: UITextField, indexPath: IndexPath) {
        switch indexPath.row {
        case DDCClientTextFieldType.channel.rawValue, DDCClientTextFieldType.career.rawValue, DDCClientTextFieldType.sex.rawValue,DDCClientTextFieldType.memberReferral.rawValue:
            do {
                textField.inputAssistantItem.leadingBarButtonGroups = []
                textField.inputAssistantItem.trailingBarButtonGroups = []
                textField.inputView = self.pickerView
                textField.inputAccessoryView = self.toolbar
            }
            break
        case DDCClientTextFieldType.birthday.rawValue:
            do {
                textField.inputAssistantItem.leadingBarButtonGroups = []
                textField.inputAssistantItem.trailingBarButtonGroups = []
                textField.inputView = self.datePickerView
                textField.inputAccessoryView = self.toolbar
            }
            break
        case DDCClientTextFieldType.email.rawValue:
            do {
                textField.inputView = nil
                textField.inputAccessoryView = nil
                textField.keyboardType = .emailAddress
            }
            break
        case DDCClientTextFieldType.channelDetail.rawValue:
            do {
                textField.inputView = nil
                textField.inputAccessoryView = nil
                textField.keyboardType = .default
            }
            break
        default:
            do {
                textField.inputView = nil
                textField.inputAccessoryView = nil
                textField.keyboardType = .phonePad
            }
            break
            
        }
    }
    
    @objc func done() {
        switch self.currentTextField?.tag {
        case DDCClientTextFieldType.birthday.rawValue:
            do {
                let dateFormatter: DateFormatter = DateFormatter.init(withFormat: "YYYY/MM/dd", locale: "")
                let birthday: Date = self.datePickerView.date
                self.models[DDCClientTextFieldType.birthday.rawValue].text = dateFormatter.string(from: birthday)
                let components = Calendar.current.dateComponents([.year], from: birthday, to: Date())
                self.models[DDCClientTextFieldType.age.rawValue].text = "\(components.year ?? 0)"
                self.models[DDCClientTextFieldType.age.rawValue].isFill = true
            }
            break
        case DDCClientTextFieldType.sex.rawValue:
            self.models[DDCClientTextFieldType.sex.rawValue].text = DDCContract.genderArray[self.pickerView.selectedRow(inComponent: 0)]
            self.models[DDCClientTextFieldType.sex.rawValue].isFill = true
            break
        case DDCClientTextFieldType.career.rawValue:
            self.models[DDCClientTextFieldType.career.rawValue].text = DDCContract.occupationArray[self.pickerView.selectedRow(inComponent: 0)]
            self.models[DDCClientTextFieldType.career.rawValue].isFill = true
            break
        case DDCClientTextFieldType.channel.rawValue:
            self.models[DDCClientTextFieldType.channel.rawValue].text = self.channels![self.pickerView.selectedRow(inComponent: 0)].name
            self.models[DDCClientTextFieldType.channel.rawValue].isFill = true
            break
        case DDCClientTextFieldType.memberReferral.rawValue:
            do {
                let isMemberReferral: String = memberReferral[self.pickerView.selectedRow(inComponent: 0)]
                self.models[DDCClientTextFieldType.memberReferral.rawValue].text = isMemberReferral
                self.models[DDCClientTextFieldType.memberReferral.rawValue].isFill = true
                //是否为会员推荐
                self.models = DDCEditClientInfoModelFactory.reloadData(models: self.models, isReferral: (isMemberReferral == "是") ? true : false)
                self.collectionView.reloadData()
            }
        default:
            break
        }

        self.collectionView.reloadData()
        self.resignFirstResponder()
    }
    
    @objc func cancel() {
        self.collectionView.reloadData()
        self.resignFirstResponder()
    }
}

// MARK: API
extension DDCEditClientInfoViewController {
    @objc func getVerificationCode(button: CountButton) {
        DDCTools.showHUD(view: self.view)
        
        if let textFieldView: DDCCircularTextFieldView = (button.superview as! DDCCircularTextFieldView) {
            let phoneNumber: String = DDCTools.removeWhiteSpace(string: textFieldView.textField.text!)
            
            guard DDCTools.isPhoneNumber(number: phoneNumber) else {
                self.view.makeDDCToast(message: "手机号有误，请检查后重试", image: UIImage.init(named: "addCar_icon_fail")!)
                DDCTools.hideHUD()
                return
            }
            
            DDCSystemUserLoginAPIManager.getUserInfo(phoneNumber: phoneNumber, successHandler: { (model) in
                DDCTools.hideHUD()
                if let _model = model {
                    self.view.makeDDCToast(message: "将自动填充用户信息\n请进行检查及补充", image: UIImage.init(named: "collect_icon_success")!)
                    self.models = DDCEditClientInfoModelFactory.integrateData(model:  _model, channels: self.channels)
                    self.collectionView.reloadData()
                } else {
                    self.view.makeDDCToast(message: "无法获取用户信息,请填写", image: UIImage.init(named: "addCar_icon_fail")!)
                }
            }) { (error) in
                self.view.makeDDCToast(message: "无法获取用户信息,请填写", image: UIImage.init(named: "addCar_icon_fail")!)
            }
        }
        
    }
    
    func getChannels() {
        DDCTools.showHUD(view: self.view)
        DDCEditClientInfoAPIManager.availableChannels(successHandler: { (array) in
            self.channels = array
        }, failHandler: { (error) in
        })
    }
}

// MARK: PickerView
extension DDCEditClientInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch self.currentTextField?.tag {
        case DDCClientTextFieldType.sex.rawValue:
            return DDCContract.genderArray.count
        case DDCClientTextFieldType.career.rawValue:
            return DDCContract.occupationArray.count
        case DDCClientTextFieldType.channel.rawValue:
            return (self.channels?.count)!
        case DDCClientTextFieldType.memberReferral.rawValue:
            return 2
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch self.currentTextField?.tag {
        case DDCClientTextFieldType.sex.rawValue:
            return DDCContract.genderArray[row]
        case DDCClientTextFieldType.career.rawValue:
            return DDCContract.occupationArray[row]
        case DDCClientTextFieldType.channel.rawValue:
            return (self.channels?.count != 0) ? (self.channels?[row] )!.name : "加载中"
        case DDCClientTextFieldType.memberReferral.rawValue:
            return memberReferral[row]
        default:
            return ""
        }
    }

}

// MARK: Textfield
extension DDCEditClientInfoViewController: UITextFieldDelegate {
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
        
        if textField.tag == DDCClientTextFieldType.phone.rawValue || textField.tag == DDCClientTextFieldType.memberPhone.rawValue {
            if (totalLength > 13) {//手机号输入长度不超过11个字符 多两个字符为分割号码用的空格
                return false
            }
            textField.text = DDCTools.splitPhoneNumber(string: textField.text!, length: totalLength)
        } else if textField.tag == DDCClientTextFieldType.channelDetail.rawValue {
            if (totalLength > 20) {//渠道详情不超过20字
                return false
            }
        } else if textField.tag == DDCClientTextFieldType.memberName.rawValue || textField.tag == DDCClientTextFieldType.sales.rawValue{
            return false
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let rawValue: Int = textField.tag

        if rawValue == DDCClientTextFieldType.phone.rawValue || rawValue == DDCClientTextFieldType.name.rawValue ||
           rawValue == DDCClientTextFieldType.age.rawValue ||
        rawValue == DDCClientTextFieldType.email.rawValue ||
            rawValue == DDCClientTextFieldType.channelDetail.rawValue || rawValue == DDCClientTextFieldType.memberPhone.rawValue || rawValue == DDCClientTextFieldType.memberName.rawValue {
            self.models[rawValue].text = textField.text
            self.models[rawValue].isFill = true
        }
        return true
    }
}

// MARK: Notification & Action
extension DDCEditClientInfoViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        UIView.animate(withDuration: 0.23) {
            self.contentView.frame = CGRect.init(x: 0.0, y: -kInputFieldViewHeight, width: screen.width, height: screen.height)
        }
        DDCKeyboardStateListener.sharedStore().isVisible = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.23) {
            self.contentView.frame = CGRect.init(x: 0, y: 0, width: screen.width, height: screen.height)
        }
        DDCKeyboardStateListener.sharedStore().isVisible = false
    }
    
    @objc func tapGestureAction() {
        self.view.endEditing(true)
    }
    
}
