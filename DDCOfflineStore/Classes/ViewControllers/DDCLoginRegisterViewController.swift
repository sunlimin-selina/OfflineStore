//
//  DDCLoginRegisterViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/9.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCLoginRegisterViewController: UIViewController {
    lazy var icon : UIImageView? = UIImageView.init(image: UIImage.init(named: "sign_logo"))
    
    lazy var backgroundImage : UIImageView? = UIImageView.init(image: UIImage.init(named: "sign_img_bg"))
    
    lazy var submitButton : DDCSubmitButton? = {
        var submitButton = DDCSubmitButton.init(frame: CGRect.zero)
        submitButton.addTarget(self, action: #selector(submitForm), for: .touchUpInside)
        submitButton.enableButtonWithType(type: .SubmitButtonTypeDefault)
        return submitButton
    }()
    
    lazy var inputFieldView : DDCInputFieldView? = {
        var inputFieldView = DDCInputFieldView.init(frame: CGRect.zero, type: .CircularTextFieldViewTypeNormal)
        return inputFieldView
    }()

    var successHandler = {(() -> Bool).self}

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func submitForm() {
        
    }
}
