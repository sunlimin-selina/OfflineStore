//
//  DDCRadioWithImageView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/5.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCRadioWithImageView: UIControl {
    enum DDCRadioStatus: UInt {
        case normal
        case image
        case textField
    }
    
    var status: DDCRadioStatus {
        get {
            return .normal
        }
        set {
            switch newValue {
            case .normal:
                do {
                    self.button.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 10.0, bottom: 0, right: 0)
                }
            case .image:
                do {
                    self.button.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 90.0, bottom: 0, right: 0)
                    self.imageView.isHidden = false
                    self.imageView.snp.makeConstraints({ (make) in
                        make.width.height.equalTo(50.0)
                        make.left.equalTo(self.button).offset(40)
                        make.centerY.equalTo(self)
                    })
                    self.button.setTitleColor(DDCColor.fontColor.black, for: .normal)
                }
            default :
                break
            }
        }
    }
    
    lazy var imageView: UIImageView = {
        var _imageView = UIImageView.init(frame: CGRect.zero)
        _imageView.contentMode = .scaleAspectFit
        _imageView.clipsToBounds = true
        _imageView.isHidden = true
        return _imageView
    }()

    lazy var button: UIButton = {
        var _button = UIButton.init()
        _button.titleLabel!.font = UIFont.systemFont(ofSize: 20.0)
        _button.setTitleColor(DDCColor.fontColor.gray, for: .normal)
        _button.setTitleColor(DDCColor.fontColor.black, for: .selected)

        _button.setImage(UIImage.init(named: "icon_selection_desselected"), for: .normal)
        _button.setImage(UIImage.init(named: "icon_selection_selected"), for: .selected)

        _button.titleLabel!.lineBreakMode = .byCharWrapping
        _button.titleLabel!.numberOfLines = 2
        _button.titleLabel!.textAlignment = .right
        _button.contentHorizontalAlignment = .left
        _button.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 10.0, bottom: 0, right: 0)
        _button.isUserInteractionEnabled = false
        return _button
    }()
    
    lazy var textField: DDCCircularTextFieldView = {
        let _textField = DDCCircularTextFieldView()
        _textField.cornerRadius = 17.0
        _textField.type = .labelButton
        _textField.button.setTitle("次", for: .normal)
        _textField.button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        _textField.button.setTitleColor(DDCColor.fontColor.gray, for: .normal)
        _textField.button.snp.updateConstraints({ (make) in
            make.width.equalTo(30.0)
        })
        _textField.isHidden = true
        return _textField
    }()
    
    convenience init(frame: CGRect, status: DDCRadioStatus) {
        self.init(frame: frame)
        self.status = status
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.button)
        self.addSubview(self.imageView)
        self.addSubview(self.textField)
        self.setupLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayoutConstraints() {
        
        self.button.snp.makeConstraints({ (make) in
            make.left.equalTo(self)
            make.right.equalTo(self.textField.snp_leftMargin)
            make.height.equalTo(30.0)
            make.centerY.equalTo(self)
            make.width.equalTo(screen.width - DDCAppConfig.kLeftMargin * 2)
        })
        
        self.textField.snp.makeConstraints({ (make) in
            make.left.equalTo(self.button.snp_rightMargin)
            make.width.equalTo(130.0)
            make.height.equalTo(34.0)
            make.centerY.equalTo(self)
        })
    }
    
    func updateButtonConstraints(width: CGFloat) {
//        let kPadding: CGFloat = 5.0
        
        self.button.snp.makeConstraints({ (make) in
            make.left.equalTo(self)
            make.right.equalTo(self.textField.snp_leftMargin)
            make.height.equalTo(30.0)
            make.centerY.equalTo(self)
            make.width.equalTo(width)
        })
        
        self.textField.snp.remakeConstraints({ (make) in
            make.left.equalTo(self.button.snp_rightMargin)
            make.width.equalTo(130.0)
            make.height.equalTo(34.0)
            make.centerY.equalTo(self)
        })
    }
    
}
