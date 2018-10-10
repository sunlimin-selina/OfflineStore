//
//  DDCLoginRegisterViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/9.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

let kOffsetHeight : CGFloat = 105.0
let kInputFieldViewHeight : CGFloat = 145.0

class DDCLoginRegisterViewController: UIViewController {
    public lazy var icon : UIImageView? = UIImageView.init(image: UIImage.init(named: "sign_logo"))
    
    public lazy var backgroundImage : UIImageView? = UIImageView.init(image: UIImage.init(named: "sign_img_bg"))
    
    public lazy var submitButton : DDCSubmitButton? = {
        var submitButton = DDCSubmitButton.init(frame: CGRect.zero)
        submitButton.addTarget(self, action: #selector(submitForm), for: .touchUpInside)
        submitButton.enableButtonWithType(type: .SubmitButtonTypeDefault)
        return submitButton
    }()
    
    public lazy var inputFieldView : DDCInputFieldView? = {
        var inputFieldView = DDCInputFieldView.init(frame: CGRect.zero, type: .CircularTextFieldViewTypeNormal)
        return inputFieldView
    }()
    
    public var successHandler : ((_ success: Bool) -> Void)?
    
    private var loginState : Bool?
    private var userNameValidated : Bool?
    private var passwordValidated : Bool?
    private var padding : Int?
    private var firstTextFieldView : DDCCircularTextFieldWithExtraButtonView?
    private lazy var contentView : UIView? = {
        var _contentView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight))
        _contentView.backgroundColor = UIColor.white
        return _contentView
    }()
    private lazy var contentLabel : UILabel? = {
        var _contentLabel = UILabel()
        _contentLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        _contentLabel.textColor = UIColor.black
        _contentLabel.text = "登录账号"
        return _contentLabel
    }()
    
    // MARK: Override
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector:Selector(("keyboardWillShow:")),
            name:UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector:Selector(("keyboardWillHide:")),
            name:UIResponder.keyboardWillHideNotification,
            object: nil)
        
        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureAction))
        self.view.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(self.backgroundImage!)
        self.view.addSubview(self.contentView!)
        self.contentView?.addSubview(self.icon!)
        self.contentView?.addSubview(self.inputFieldView!)
        self.contentView?.addSubview(self.submitButton!)
        self.contentView?.addSubview(self.contentLabel!)
        
    }

    class func loginWithTarget(targetController: UIViewController, successHandler:@escaping ((_ success: Bool) -> Void)){
        let loginViewController : DDCLoginRegisterViewController = DDCLoginRegisterViewController()
        loginViewController.successHandler = successHandler
        
        let loginNavigationController : UINavigationController = UINavigationController.init(rootViewController: loginViewController)
        loginNavigationController.modalPresentationStyle = .fullScreen
        targetController.present(loginNavigationController, animated: true, completion: nil)
    }
}

// MARK: Notification & Action
extension DDCLoginRegisterViewController {
    
    @objc func keyboardWillShow(notification : NSNotification) {
        UIView.animate(withDuration: 0.23) {
            self.icon!.alpha = 0;
            self.contentView!.frame = CGRect.init(x: 0.0, y: -kOffsetHeight, width: screenWidth, height: screenHeight)
        }
        DDCKeyboardStateListener.sharedStore().isVisible = true
    }
    
    @objc func keyboardWillHide(notification : NSNotification) {
        UIView.animate(withDuration: 0.23) {
            self.icon!.alpha = 1;
            self.contentView!.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight)
        }
        DDCKeyboardStateListener.sharedStore().isVisible = false
    }
    
    @objc func tapGestureAction() {
        self.view.endEditing(true)
    }
    
}

// MARK:Private
extension DDCLoginRegisterViewController {
    func setupViewConstraints() {
        let kSize = 24.0
        let kIconWidth = 208.0
        let kTopMargin = 30.0
        
        self.backgroundImage?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
        
        self.icon?.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.contentView!)
            make.top.equalTo(self.contentView!.snp_topMargin).offset(212.0)
            make.width.equalTo(kIconWidth)
            make.height.equalTo(kSize)
        })
        
        self.contentLabel?.snp.makeConstraints({ (make) in make.top.equalTo(self.icon!.snp_bottomMargin).offset(50)
            make.centerX.equalTo(self.view!)
        })
        
        self.inputFieldView?.snp.makeConstraints({ (make) in         make.top.equalTo(self.icon!.snp_bottomMargin).offset(102.0)
            make.width.centerX.equalTo(self.contentView!)
            make.height.equalTo(kInputFieldViewHeight)
        })
        
        self.submitButton?.snp.makeConstraints({ (make) in                 make.top.equalTo(self.inputFieldView!.snp_bottomMargin).offset(kTopMargin)
            make.width.height.equalTo(45.0)
            make.centerX.equalTo(self.contentView!);
        })
    }
    
    func checkPhoneNumberOrEmail(string : String) -> Bool{
        if let _ : String = string {
            self.view.makeDDCToast(message:"请输入用户名", image: UIImage.init(named: "addCar_icon_fail")!)
            return false
        }
        return true
    }
    
    func loginActionWithUserName(userName: String, password: String) {
        //    [Tools showHUDAddedTo:self.view animated:YES];
        //        self.submitButton?.isEnabled = false
        //        [DDCSystemUserLoginAPIManager loginWithUsername:userName password:password successHandler:^(DDCUserModel *user) {
        //            [DDCStore sharedStore].user = user;
        //            [Tools showHUDAddedTo:self.view animated: NO];
        //            if (self.successHandler)
        //            {
        //            self.successHandler(YES);
        //            }
        //            } failHandler:^(NSError *err) {
        //            self.submitButton.enabled = YES;
        //            [Tools showHUDAddedTo:self.view animated: NO];
        //            NSString * errStr = err.userInfo[NSLocalizedDescriptionKey];
        //            [self.view makeDDCToast:errStr image:[UIImage imageNamed:@"addCar_icon_fail"]];
        //            }];
    }
}

// MARK:UITextFieldDelegate
extension DDCLoginRegisterViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //限制字符长度
        let existedLength: Int = textField.text!.count
        let selectedLength: Int = range.length
        let replaceLength: Int = string.count
        
        if (textField == self.inputFieldView?.firstTextFieldView!.textField) {
            if (existedLength - selectedLength + replaceLength > 11) {//手机号输入长度不超过11个字符
                return false
            }
        } else if (textField == self.inputFieldView?.secondTextFieldView!.textField){//密码输入长度不超过20个字符
            if (existedLength - selectedLength + replaceLength > 20) {
                return false
            }
        }
        return true
    }
    
    func textFieldDidChange(textField: UITextField) {
        if (textField == self.inputFieldView?.firstTextFieldView!.textField) {
            self.userNameValidated = textField.text!.count > 0
        } else {
            self.passwordValidated = false
            if ((textField.text?.count) != nil) {//输入6位密码
                self.passwordValidated = true
            }
        }
        
        if self.userNameValidated! ,
            self.passwordValidated! {
            self.submitButton?.enableButtonWithType(type: .SubmitButtonTypeNext)
        } else {
            self.submitButton?.enableButtonWithType(type: .SubmitButtonTypeDefault)
        }
    }
    
}

// MARK:InputFieldViewDelegate
extension DDCLoginRegisterViewController : InputFieldViewDelegate {
    func inputFieldView(view: DDCInputFieldView, quickLogin: Bool) {
        self.firstTextFieldView!.type = .CircularTextFieldViewTypeNormal
        self.submitButton?.enableButtonWithType(type: .SubmitButtonTypeDefault)
    }
    
    func getVerificationCodeClick(sender: CountButton) {
        self.view.endEditing(true)

        if self.loginState! {
            self.firstTextFieldView!.button!.isEnabled = false
        } else {
            self.firstTextFieldView!.extraButton!.isEnabled = false
        }
        
        let phoneNumber : String = self.inputFieldView!.firstTextFieldView!.textField!.text!
        
        if let _ : String = phoneNumber {
            self.view.makeDDCToast(message: "请输入手机号", image: UIImage.init(named: "addCar_icon_fail")!)
            return
        }
        
        if !DDCTools.isPhoneNumber(number: phoneNumber) {
            self.view.makeDDCToast(message: "您输入手机号有误，请检查!", image: UIImage.init(named: "addCar_icon_fail")!)
            return
        }
        
        if (sender.counting!) {
            return
        }

        var type : String = "2"
        if !(self.loginState!) {
            type = "0"
        }
    }
    
    @objc func submitForm() {
        self.view.endEditing(true)
        let userName = self.inputFieldView!.firstTextFieldView!.textField!.text
        let password = self.inputFieldView!.secondTextFieldView!.textField!.text
        
        if !self.checkPhoneNumberOrEmail(string: userName!) {
            return
        }
        
        if !(password != nil),
            password!.count <= 0
        {
            self.view.makeDDCToast(message: "请输入密码!", image: UIImage.init(named: "addCar_icon_fail")!)
            return
        }
        
        self.loginActionWithUserName(userName: userName!, password: password!)
    }
    
}
