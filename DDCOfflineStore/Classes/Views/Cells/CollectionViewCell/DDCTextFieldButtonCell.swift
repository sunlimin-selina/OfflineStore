//
//  DDCTextFieldButtonCell.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/22.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCTextFieldButtonCell: UICollectionViewCell {
    static let kTextFieldViewHeight: CGFloat = 50.0
    
    public lazy var titleLabel: DDCContractLabel = {
        let titleLabel: DDCContractLabel = DDCContractLabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return titleLabel
    }()
    
    public lazy var button: UIButton = {
        let _button: UIButton = UIButton()
        _button.backgroundColor = DDCColor.mainColor.red
        _button.setTitle("扫一扫", for: .normal)
        _button.setTitle("重新扫描", for: .selected)
        _button.setTitleColor(UIColor.white, for: .normal)
        _button.layer.cornerRadius = DDCTextFieldButtonCell.kTextFieldViewHeight / 2
        _button.layer.shadowColor = DDCColor.mainColor.red.cgColor
        _button.layer.shadowRadius = 5.0
        _button.layer.shadowOpacity = 0.4
        _button.layer.shadowOffset = CGSize.init(width: 0.0, height: 2.0)
        return _button
    }()
    
    public lazy var textFieldView: DDCCircularTextFieldView = {
        let _textFieldView = DDCCircularTextFieldView.init(frame: CGRect.zero)
        _textFieldView.cornerRadius = DDCTitleTextFieldCell.kTextFieldViewHeight / 2
        return _textFieldView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.textFieldView)
        self.contentView.addSubview(self.button)
        self.setupViewConstraints()
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        
        let kShadowMargin: CGFloat = 5.0
        
        self.titleLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(kShadowMargin)
        })
        
        self.textFieldView.snp.makeConstraints({ (make) in
            make.left.equalTo(self.titleLabel)
            make.right.equalTo(self.button.snp_leftMargin).offset(-20.0)
            make.bottom.equalTo(self.contentView).offset(-10)
            make.height.equalTo(DDCTitleTextFieldCell.kTextFieldViewHeight)
        })
        
        self.button.snp.makeConstraints { (make) in
            make.left.equalTo(self.textFieldView.snp_rightMargin).offset(20)
            make.width.equalTo(120)
            make.bottom.equalTo(self.textFieldView)
            make.height.equalTo(DDCTitleTextFieldCell.kTextFieldViewHeight)
            make.right.equalTo(self.contentView)
        }
        
    }
    
    func configureCell(model: DDCContractInfoViewModel, indexPath: IndexPath, showHint: Bool) {
        let _showHint = showHint
        self.titleLabel.configure(title: model.title ?? "", isRequired: model.isRequired!, tips: model.tips!, isShowTips:_showHint)
        self.textFieldView.textField.attributedPlaceholder = NSAttributedString.init(string:model.placeholder!, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18.0)])
        self.textFieldView.textField.text = model.text
        self.textFieldView.textField.tag = indexPath.row
    }
}
