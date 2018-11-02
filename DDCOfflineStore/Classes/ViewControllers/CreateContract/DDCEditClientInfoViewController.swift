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
    }
    
    var models: [DDCContractInfoViewModel] = DDCEditClientInfoModelFactory.integrateData(model:  DDCCustomerModel(), channels: [DDCChannelModel()])
    var channels: [DDCChannelModel]? = Array()
    var currentTextField: UITextField?
    
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
        _collectionView.isScrollEnabled = false
        _collectionView.register(DDCTitleTextFieldCell.self, forCellWithReuseIdentifier: String(describing: DDCTitleTextFieldCell.self))
        _collectionView.backgroundColor = UIColor.white
        _collectionView.delegate = self
        _collectionView.dataSource = self
        return _collectionView
    }()
    
    private lazy var bottomBar : DDCBottomBar = {
        let _bottomBar : DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 10.0, y: 10.0, width: 10.0, height: 10.0))
        _bottomBar.addButton(button:DDCBarButton.init(title: "下一步", style: .highlighted, handler: {
        
        }))
        return _bottomBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        _isFirstBlood = YES;
        
        self.getChannels()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.bottomBar)
        self.setupViewConstraints()
    }
}

// MARK: private
extension DDCEditClientInfoViewController {
    private func setupViewConstraints() {
        let kBarHeight : CGFloat = 60.0
        self.collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-kBarHeight)
        }
        
        self.bottomBar.snp.makeConstraints({ (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(kBarHeight)
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp_bottomMargin).offset(-kBarHeight)
        })
    }
    
    func update() {
        var customerModel: DDCCustomerModel = DDCCustomerModel.init()
        //        self.model = [DDCContractModel contractWithCustomer:customerModel existingModel:self.model];
        
        self.model?.customer?.userName = self.models[DDCClientTextFieldType.phone.rawValue].text
        self.model?.customer?.nickName = self.models[DDCClientTextFieldType.name.rawValue].text
//        self.model?.customer?.sex = self.models[DDCClientTextFieldType.sex.rawValue].text
//        self.model?.customer?.birthday = self.models[DDCClientTextFieldType.birthday.rawValue].text

        self.model?.customer?.age = self.models[DDCClientTextFieldType.age.rawValue].text
        self.model?.customer?.email = self.models[DDCClientTextFieldType.email.rawValue].text
        self.model?.customer?.career = self.models[DDCClientTextFieldType.career.rawValue].text

//        NSUInteger idx = [self.availableChannels indexOfObjectPassingTest:^BOOL(DDCChannel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        return [obj.name isEqualToString:self.viewModelArray[DDCClientTextFieldChannel].text];
//        }];
//        self.model.customer.channel = idx != NSNotFound ? @(self.availableChannels[idx].ID.integerValue) : nil;
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
        cell.configureCell(model: model, indexPath: indexPath)
        cell.textFieldView.textField?.delegate = self
        cell.textFieldView.button?.addTarget(self, action: #selector(getVerificationCode(button:)), for: .touchUpInside)
        self.configureInputView(textField: cell.textFieldView.textField!, indexPath: indexPath)
        
        // 不让用户手动改年龄
        cell.textFieldView.textField?.isUserInteractionEnabled = indexPath.item != DDCClientTextFieldType.age.rawValue
        cell.textFieldView.textField?.clearButtonMode = (indexPath.item == DDCClientTextFieldType.age.rawValue) ? .never : .always
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item != DDCClientTextFieldType.birthday.rawValue,
            indexPath.item != DDCClientTextFieldType.age.rawValue
        {
            return CGSize.init(width: 500, height: 75)
        } else if  indexPath.item == DDCClientTextFieldType.age.rawValue{
            return CGSize.init(width: 100, height: 75)
        } else {
            return CGSize.init(width: 340, height: 75)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: (screen.width - 500)/2, bottom: 0, right: (screen.width - 500)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 60.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 35.0
    }
    
}

// MARK: Private
extension DDCEditClientInfoViewController {
    func configureInputView(textField: UITextField, indexPath: IndexPath) {
        switch indexPath.row {
        case DDCClientTextFieldType.channel.rawValue, DDCClientTextFieldType.career.rawValue, DDCClientTextFieldType.sex.rawValue:
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
            }
            break
        case DDCClientTextFieldType.sex.rawValue:
            self.models[DDCClientTextFieldType.sex.rawValue].text = DDCContract.genderArray[self.pickerView.selectedRow(inComponent: 0)]
            break
        case DDCClientTextFieldType.career.rawValue:
            self.models[DDCClientTextFieldType.career.rawValue].text = DDCContract.occupationArray[self.pickerView.selectedRow(inComponent: 0)]
            break
        case DDCClientTextFieldType.channel.rawValue:
            self.models[DDCClientTextFieldType.channel.rawValue].text = self.channels![self.pickerView.selectedRow(inComponent: 0)].name
            break
        default:
            break
        }

        self.collectionView.reloadData()
        self.resignFirstResponder()
    }
    
    @objc func cancel() {
        self.resignFirstResponder()
    }
}

// MARK: API
extension DDCEditClientInfoViewController {
    @objc func getVerificationCode(button: CountButton) {
        DDCTools.showHUD(view: self.view)
        
        if let textFieldView: DDCCircularTextFieldView = (button.superview as! DDCCircularTextFieldView) {
            let phoneNumber: String = (textFieldView.textField?.text)!
            
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
        return true
    }
}
