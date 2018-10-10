//
//  DDCLoginRegisterViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/9.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit


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
    
    public var successHandler = {(() -> Bool).self}

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
    
}

// MARK: Notification & Action
extension DDCLoginRegisterViewController {
    
    @objc func keyboardWillShow(notification : NSNotification) {
        UIView.animate(withDuration: 0.23) {
            self.icon!.alpha = 0;
            self.contentView!.frame = CGRect.init(x: 0.0, y: -kOffsetHeight, width: screenWidth, height: screenHeight)
        }
    }
    
    @objc func keyboardWillHide(notification : NSNotification) {
        UIView.animate(withDuration: 0.23) {
            self.icon!.alpha = 1;
            self.contentView!.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight)
        }
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
    
    func checkPhoneNumberOrEmail(string : String) {
 
    }
    
    @objc func submitForm() {
        
    }
}
