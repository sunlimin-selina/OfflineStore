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
    
    enum DDCClientTextFieldType: Int{
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
        case introduceMobile
        case introduceName
        case sales
    }
    
    var models: [DDCContractInfoViewModel] = DDCEditClientInfoModelFactory.integrateData(model:  DDCCustomerModel(), channels: [DDCChannelModel()])
    var channels: [DDCChannelModel]? = Array()
    var currentTextField: UITextField?
    var memberReferral = ["是","否"]
    var showHint: Bool = false
    var isRightReferral: Bool = false
    var model: DDCContractModel? {
        get {
            if _model == nil {
                _model = DDCContractModel.init()
                let customer: DDCCustomerModel = DDCCustomerModel()
                _model?.customer = customer
            }
            return _model
        }
        set {
            _model = newValue
        }
    }
    
    private lazy var contentView: UIView = {
        var _contentView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screen.width, height: screen.height))
        _contentView.backgroundColor = UIColor.white
        return _contentView
    }()
    
    private lazy var bottomBar: DDCBottomBar = {
        let _bottomBar: DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 10.0, y: 10.0, width: screen.width, height: DDCAppConfig.kBarHeight))
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.getChannels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                    self.bottomBar.buttonArray![0].isEnabled = true
                    self.collectionView.reloadData()
                    return
                }
            }
            if index == DDCClientTextFieldType.email.rawValue,
                (model.text?.count)! > 0,
                let email = model.text{
                guard DDCTools.validateEmail(email: email) else {
                    self.view.makeDDCToast(message: "邮箱格式不对，请输入准确的邮箱地址", image: UIImage.init(named: "addCar_icon_fail")!)
                    self.bottomBar.buttonArray![0].isEnabled = true
                    self.collectionView.reloadData()
                    return
                }
            }
        }
        
        if !self.isRightReferral && (self.model?.customer?.isReferral)! && (self.model!.customer!.introduceName == nil || self.model!.customer!.introduceName!.count == 0) {
            self.bottomBar.buttonArray![0].isEnabled = true
            self.view.makeDDCToast(message: "介绍客户信息有误，请检查", image: UIImage.init(named: "addCar_icon_fail")!)
            return
        }
        self.updateTextFieldValue()
        
        if !canForward {
            self.bottomBar.buttonArray![0].isEnabled = true
        }
        
        //注册用户信息
        self.uploadUserInfo(model: self.model!)
    }
    
    func updateTextFieldValue() {
        self.model!.customer?.mobile = DDCTools.removeWhiteSpace(string: self.models[DDCClientTextFieldType.phone.rawValue].text!)
        self.model!.customer?.name = self.models[DDCClientTextFieldType.name.rawValue].text ?? ""
        //邮箱
        self.model!.customer?.email = self.models[DDCClientTextFieldType.email.rawValue].text ?? ""
        //渠道详情
        self.model!.customer?.channelDesc = self.models[DDCClientTextFieldType.channelDetail.rawValue].text ?? ""
        //是否会员介绍
        if (self.model!.customer?.isReferral)! {
            //会员手机号
            self.model!.customer?.introduceMobile = DDCTools.removeWhiteSpace(string: self.models[DDCClientTextFieldType.introduceMobile.rawValue].text ?? "")
            //会员姓名
            self.model!.customer?.introduceName = self.models[DDCClientTextFieldType.introduceName.rawValue].text ?? ""
        }
        
    }
    
    func configureCell(cell: DDCTitleTextFieldCell, model: DDCContractInfoViewModel, indexPath: IndexPath, showHint: Bool) {
        var _showHint = showHint
        cell.textFieldView.textField.isUserInteractionEnabled = true
        cell.textFieldView.textField.clearButtonMode = .always
        cell.textFieldView.type = .normal
        cell.textFieldView.button.setTitleColor(DDCColor.mainColor.red, for: .normal)
        
        if indexPath.item == 0 {
            _showHint = true
            cell.textFieldView.type = .labelButton
            cell.textFieldView.button.isHidden = false
            cell.textFieldView.button.setTitle("获取用户信息", for: .normal)
            cell.textFieldView.button.addTarget(self, action: #selector(getUserInfo(button:)), for: .touchUpInside)
        } else if (indexPath.item == 1 && model.text!.count > 0) {
            cell.textFieldView.type = .labelButton
            cell.textFieldView.button.isHidden = false
            cell.textFieldView.button.isEnabled = false
            cell.textFieldView.button.setTitle(model.descriptions, for: .normal)
            cell.textFieldView.button.setTitleColor(UIColor.black, for: .normal)
            cell.textFieldView.button.snp.updateConstraints({ (make) in
                make.width.equalTo(50.0)
            })
        } else if (indexPath.item == 10 && model.title == "介绍会员电话") {
            cell.textFieldView.type = .labelButton
            cell.textFieldView.button.setTitle("会员验证", for: .normal)
            cell.textFieldView.button.isHidden = (self.model?.customer!.type == DDCCustomerType.potential || self.model?.customer!.type == DDCCustomerType.regular)
            cell.textFieldView.button.addTarget(self, action: #selector(getUserInfo(button:)), for: .touchUpInside)
        } else if (indexPath.item == 4) {
            // 不让用户手动改年龄
            cell.textFieldView.textField.clearButtonMode = .never
        } else if (indexPath.item == 11 && model.title == "介绍会员姓名") || (indexPath.item == 12) || (indexPath.item == 10 && model.title == "责任销售") {
            cell.textFieldView.textField.isUserInteractionEnabled = false
            cell.textFieldView.textField.clearButtonMode = .never
        } else if (self.model?.customer?.type == DDCCustomerType.potential || self.model?.customer?.type == DDCCustomerType.regular) && indexPath.item > 6 {
            cell.textFieldView.textField.clearButtonMode = .never
        }
        
        cell.titleLabel.configure(title: model.title ?? "", isRequired: model.isRequired!, tips: model.tips!, isShowTips:_showHint)
        cell.textFieldView.textField.attributedPlaceholder = NSAttributedString.init(string:model.placeholder!, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18.0)])
        cell.textFieldView.textField.text = model.text
        cell.textFieldView.textField.tag = indexPath.row
        cell.textFieldView.textField.delegate = self
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
            return CGSize.init(width: 320 * screen.X_Scale , height: 90)
        } else if  indexPath.item == DDCClientTextFieldType.age.rawValue || indexPath.item == DDCClientTextFieldType.sex.rawValue{
            return CGSize.init(width: 120  * screen.X_Scale , height: 90)
        } else {
            return CGSize.init(width: DDCAppConfig.width, height: 90)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let margin: CGFloat = DDCAppConfig.kLeftMargin
        return UIEdgeInsets.init(top: 0, left: margin, bottom: 0, right: margin)
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
        case DDCClientTextFieldType.channelDetail.rawValue ,
             DDCClientTextFieldType.name.rawValue:
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
                self.model?.customer?.birthday = DDCTools.dateToTimeInterval(from: birthday)
                self.models[DDCClientTextFieldType.birthday.rawValue].text = dateFormatter.string(from: birthday)
                let components = Calendar.current.dateComponents([.year], from: birthday, to: Date())
                self.model?.customer?.age = "\(components.year ?? 0)"
                self.models[DDCClientTextFieldType.age.rawValue].text = "\(components.year ?? 0)岁"
                self.models[DDCClientTextFieldType.age.rawValue].isFill = true
            }
            break
        case DDCClientTextFieldType.sex.rawValue:
            let sex: String = DDCContract.genderArray[self.pickerView.selectedRow(inComponent: 0)]
            self.model?.customer?.sex = DDCGender(rawValue: DDCContract.genderArray.index(of: sex)!)
            self.models[DDCClientTextFieldType.sex.rawValue].text = sex
            self.models[DDCClientTextFieldType.sex.rawValue].isFill = true
            break
        case DDCClientTextFieldType.career.rawValue:
            let career: String = DDCContract.occupationArray[self.pickerView.selectedRow(inComponent: 0)]
            self.model?.customer?.career = DDCOccupation(rawValue: DDCContract.occupationArray.index(of: career)! + 1)
            self.models[DDCClientTextFieldType.career.rawValue].text = career
            self.models[DDCClientTextFieldType.career.rawValue].isFill = true
            break
        case DDCClientTextFieldType.channel.rawValue:
            if self.channels != nil, (self.channels?.count)! > 0
            {
                let _channel: DDCChannelModel = self.channels![self.pickerView.selectedRow(inComponent: 0)]
                self.model?.customer!.channelCode = _channel.code
                self.models[DDCClientTextFieldType.channel.rawValue].text = _channel.name
                self.models[DDCClientTextFieldType.channel.rawValue].isFill = true
                self.models[DDCClientTextFieldType.channelDetail.rawValue].isRequired = _channel.descStatus == 1 ? true : false  //渠道详情是否必填
            }
            break
        case DDCClientTextFieldType.memberReferral.rawValue:
            do {
                let isMemberReferral: String = memberReferral[self.pickerView.selectedRow(inComponent: 0)]
                self.model!.customer?.isReferral = isMemberReferral == "是" ? true : false
                self.models[DDCClientTextFieldType.memberReferral.rawValue].text = isMemberReferral
                self.models[DDCClientTextFieldType.memberReferral.rawValue].isFill = true
                //是否为会员推荐
                self.models = DDCEditClientInfoModelFactory.reloadData(models: self.models, customer: nil, isReferral: (isMemberReferral == "是") ? true: false)
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
    @objc func getUserInfo(button: CountButton) {
        self.resignFirstResponder()
        
        let _textFieldView: DDCCircularTextFieldView = (button.superview as! DDCCircularTextFieldView)
        let phoneNumber: String = DDCTools.removeWhiteSpace(string: _textFieldView.textField.text!)
        guard DDCTools.isPhoneNumber(number: phoneNumber) else {
            self.view.makeDDCToast(message: "手机号有误，请检查后重试", image: UIImage.init(named: "addCar_icon_fail")!)
            return
        }
        
        //判断介绍会员是否为当前用户
        if phoneNumber == self.model?.customer?.mobile {
            if _textFieldView.textField.tag != 0 {
                self.view.makeDDCToast(message: "介绍会员不能为当前客户", image: UIImage.init(named: "addCar_icon_fail")!)
                return
            }
        }
        
        DDCTools.showHUD(view: self.view)
        
        DDCSystemUserLoginAPIManager.getUserInfo(phoneNumber: phoneNumber, successHandler: { (model) in
            DDCTools.hideHUD()
            if let _model = model {
                if _textFieldView.textField.tag == 0 {
                    self.view.makeDDCToast(message: "将自动填充用户信息\n请进行检查及补充", image: UIImage.init(named: "collect_icon_success")!)
                    self.model?.customer? = _model
                    self.models = DDCEditClientInfoModelFactory.integrateData(model: self.model!.customer!, channels: self.channels)
                } else {
                    let customer: DDCCustomerModel = DDCCustomerModel.init()
                    customer.introduceMobile = model?.mobile
                    customer.introduceName = model?.name
                    self.isRightReferral = true
                    self.models = DDCEditClientInfoModelFactory.reloadData(models: self.models, customer: customer, isReferral: true)
                }
            } else {
                if _textFieldView.textField.tag == 0 {
                    self.view.makeDDCToast(message: "无法获取用户信息,请填写", image: UIImage.init(named: "addCar_icon_fail")!)
                    self.model!.customer = DDCCustomerModel()
                    self.model!.customer!.mobile = phoneNumber
                    self.model!.customer!.type = DDCCustomerType.new
                    self.models = DDCEditClientInfoModelFactory.integrateData(model: self.model!.customer!, channels: self.channels)
                } else {
                    if self.model != nil && self.model!.customer != nil {
                        self.model!.customer!.introduceMobile = nil
                        self.model!.customer!.introduceName = nil
                        self.model!.customer!.type = DDCCustomerType.new
                    }
                    self.isRightReferral = false
                    
                    self.view.makeDDCToast(message: "无法找到对应客户，请检查", image: UIImage.init(named: "addCar_icon_fail")!)
                }
            }
            self.collectionView.reloadData()
        }) { (error) in
            DDCTools.hideHUD()
            self.isRightReferral = false
            self.view.makeDDCToast(message: "无法获取用户信息,请填写", image: UIImage.init(named: "addCar_icon_fail")!)
        }
        
    }
    
    func getChannels() {
        DDCTools.showHUD(view: self.view)
        DDCEditClientInfoAPIManager.availableChannels(successHandler: { [unowned self] (array) in
            DDCTools.hideHUD()
            self.channels = array
            }, failHandler: { (error) in
                DDCTools.hideHUD()
        })
    }
    
    func uploadUserInfo(model:DDCContractModel) {
        DDCTools.showHUD(view: self.view)
        DDCEditClientInfoAPIManager.uploadUserInfo(model: model, successHandler: { [unowned self] (model) in
            DDCTools.hideHUD()
            if let _model = model {
                self.delegate?.nextPage(model: _model)
            } else {
                self.view.makeDDCToast(message: "保存用户信息失败", image: UIImage.init(named: "addCar_icon_fail")!)
            }
            self.bottomBar.buttonArray![0].isEnabled = true
            
        }) { [unowned self] (error) in
            DDCTools.hideHUD()
            self.bottomBar.buttonArray![0].isEnabled = true
            self.view.makeDDCToast(message: error, image: UIImage.init(named: "addCar_icon_fail")!)
        }
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
            return (self.channels?.count != 0) ? (self.channels?[row] )!.name: "加载中"
        case DDCClientTextFieldType.memberReferral.rawValue:
            return memberReferral[row]
        default:
            return ""
        }
    }
    
}

// MARK: Textfield
extension DDCEditClientInfoViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField.tag == DDCClientTextFieldType.introduceMobile.rawValue {
            self.models[DDCClientTextFieldType.introduceMobile.rawValue].text = ""
            self.models[DDCClientTextFieldType.introduceMobile.rawValue].isFill = false
            self.models[DDCClientTextFieldType.introduceName.rawValue].text = ""
            self.collectionView.reloadData()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.currentTextField = textField
        self.pickerView.reloadAllComponents()
        let rawValue: Int = textField.tag
        if (self.model?.customer?.type == DDCCustomerType.potential || self.model?.customer?.type == DDCCustomerType.regular) && (
            rawValue == DDCClientTextFieldType.channel.rawValue ||
                rawValue == DDCClientTextFieldType.channelDetail.rawValue || rawValue == DDCClientTextFieldType.introduceMobile.rawValue || rawValue == DDCClientTextFieldType.introduceName.rawValue || rawValue == DDCClientTextFieldType.memberReferral.rawValue || rawValue == DDCClientTextFieldType.sales.rawValue ) {
            return false
        } else if rawValue == DDCClientTextFieldType.age.rawValue {
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //限制字符长度
        let existedLength: Int = (textField.text?.count)!
        let selectedLength: Int = range.length
        let replaceLength: Int = string.count
        let totalLength: Int = existedLength - selectedLength + replaceLength
        
        if textField.tag == DDCClientTextFieldType.phone.rawValue || textField.tag == DDCClientTextFieldType.introduceMobile.rawValue {
            if (totalLength > 13) {//手机号输入长度不超过11个字符 多两个字符为分割号码用的空格
                return false
            }
            textField.text = DDCTools.splitPhoneNumber(string: textField.text!, length: totalLength)
        } else if textField.tag == DDCClientTextFieldType.channelDetail.rawValue {
            if (totalLength > 20) {//渠道详情不超过20字
                return false
            }
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let rawValue: Int = textField.tag
        
        if rawValue == DDCClientTextFieldType.phone.rawValue || rawValue == DDCClientTextFieldType.name.rawValue ||
            rawValue == DDCClientTextFieldType.age.rawValue ||
            rawValue == DDCClientTextFieldType.email.rawValue ||
            rawValue == DDCClientTextFieldType.channelDetail.rawValue || rawValue == DDCClientTextFieldType.introduceMobile.rawValue || rawValue == DDCClientTextFieldType.introduceName.rawValue  {
            self.models[rawValue].text = textField.text
            self.models[rawValue].isFill = (textField.text?.count)! > 0 ? true : false
        }
        return true
    }
}

// MARK: Notification & Action
extension DDCEditClientInfoViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        UIView.animate(withDuration: 0.23) {
            self.contentView.frame = CGRect.init(x: 0.0, y: -kInputFieldViewHeight - DDCAppConfig.kBarHeight, width: screen.width, height: screen.height)
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
