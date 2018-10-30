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
        case sex = 2
        case birthday = 3
        case email = 5
        case career = 6
        case channel = 7
    }
    
    var models: [DDCContractInfoViewModel] = DDCEditClientInfoModelFactory.integrateData(model:  DDCCustomerModel(), channels: [DDCChannelModel()])
    var channels: [DDCChannelModel]? = Array()
    var currentTextField: UITextField?
    
    private lazy var toolbar: DDCToolbar = {
        let _toolbar = DDCToolbar.init(frame: CGRect.init(x: 0, y: 0, width: screen.width, height: 40.0))
        _toolbar.cancelButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        _toolbar.doneButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
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
    
    private lazy var tableView: UITableView = {
        let _tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        _tableView.register(DDCTitleTextFieldCell.self, forCellReuseIdentifier: String(describing: DDCTitleTextFieldCell.self))
        _tableView.rowHeight = 80.0
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.isUserInteractionEnabled = true
        _tableView.separatorColor = UIColor.white
        return _tableView
    }()
    
    private lazy var bottomBar : DDCBottomBar = {
        let _bottomBar : DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 10.0, y: 10.0, width: 10.0, height: 10.0))
        _bottomBar.addButton(button:DDCBarButton.init(title: "下一步", style: .forbidden, handler: {
            let viewController : DDCCreateContractViewController = DDCCreateContractViewController.init(progress: .DDCContractProgressAddPhoneNumber, model: nil)
            self.navigationController?.pushViewController(viewController, animated: true)
        }))
        return _bottomBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        _isFirstBlood = YES;

        self.getChannels()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.bottomBar)
        self.setupViewConstraints()
    }
}

// MARK: private
extension DDCEditClientInfoViewController {
    private func setupViewConstraints() {
        let kBarHeight : CGFloat = 60.0
        self.tableView.snp.makeConstraints { (make) in
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
}

// MARK: UITableViewDelegate
extension DDCEditClientInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (self.tableView.dequeueReusableCell(withIdentifier: String(describing: DDCTitleTextFieldCell.self), for: indexPath)) as! DDCTitleTextFieldCell
        let model: DDCContractInfoViewModel = self.models[indexPath.item]
        cell.configureCell(model: model, indexPath: indexPath)
        cell.textFieldView.textField?.delegate = self
        cell.textFieldView.button?.addTarget(self, action: #selector(getVerificationCode(button:)), for: .touchUpInside)
        self.configureInputView(textField: cell.textFieldView.textField!, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126.0
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
                textField.keyboardType = .phonePad
            }
            break
            
        }
    }
    
    @objc func done() {
        switch self.currentTextField?.tag {
        case DDCClientTextFieldType.birthday.rawValue:
            do {
//                NSDate * birthday = self.datePickerView.date;
//                self.viewModelArray[DDCClientTextFieldBirthday].text = [self.dateFormatter stringFromDate:birthday];
//                NSCalendarUnit unitFlags = NSCalendarUnitYear;
//                NSDateComponents *breakdownInfo = [[NSCalendar currentCalendar] components:unitFlags fromDate:birthday  toDate:[DDCServerDate sharedInstance].today  options:0];
//
//                self.viewModelArray[DDCClientTextFieldAge].text = @(breakdownInfo.year).stringValue;
            }
            break
        case DDCClientTextFieldType.sex.rawValue:
//            self.viewModelArray[DDCClientTextFieldSex].text = DDCCustomerModel.genderArray[[self.pickerView selectedRowInComponent:0]];
            break
        case DDCClientTextFieldType.career.rawValue:
//            self.viewModelArray[DDCClientTextFieldCareer].text = DDCCustomerModel.occupationArray[[self.pickerView selectedRowInComponent:0]];
            break
        case DDCClientTextFieldType.channel.rawValue:
//            self.viewModelArray[DDCClientTextFieldChannel].text = self.availableChannels[[self.pickerView selectedRowInComponent:0]].name;
            break
        default:
            break
        }
//        NSArray * refreshIndexes = @[[NSIndexPath indexPathForItem:_currentTextField.tag inSection:0]];
//        if (_currentTextField.tag == DDCClientTextFieldBirthday)
//        {
//            refreshIndexes = [refreshIndexes arrayByAddingObjectsFromArray:@[[NSIndexPath indexPathForItem:DDCClientTextFieldAge inSection:0]]];
//        }
        self.tableView.reloadData()
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
//        if (!_phoneValidated)
//        {
//            [self.view makeDDCToast:NSLocalizedString(@"手机号有误，请检查后重试", @"") image:[UIImage imageNamed:@"addCar_icon_fail"]];
//            [Tools hiddenHUDFromSuperview];
//            return;
//        }
        DDCSystemUserLoginAPIManager.getUserInfo(phoneNumber: "15921516376", successHandler: { (model) in
            DDCTools.hideHUD()
            if let _model = model {
                self.view.makeDDCToast(message: "将自动填充用户信息\n请进行检查及补充", image: UIImage.init(named: "collect_icon_success")!)
                self.models = DDCEditClientInfoModelFactory.integrateData(model:  _model, channels: self.channels)
                self.tableView.reloadData()
            } else {
                self.view.makeDDCToast(message: "无法获取用户信息,请填写", image: UIImage.init(named: "addCar_icon_fail")!)
            }
        }) { (error) in
            self.view.makeDDCToast(message: "无法获取用户信息,请填写", image: UIImage.init(named: "addCar_icon_fail")!)
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
