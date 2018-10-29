//
//  DDCTitleTextFieldCell.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/26.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCTitleTextFieldCell: UITableViewCell {
    static let kTextFieldViewHeight: CGFloat = 45.0
    static let kCellWidth: CGFloat = 500.0

    public lazy var titleLabel: DDCContractLabel = {
        let titleLabel : DDCContractLabel = DDCContractLabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = DDCColor.fontColor.black
        return titleLabel
    }()
    
    public lazy var textFieldView: DDCCircularTextFieldView = {
        let _textFieldView = DDCCircularTextFieldView.init(frame: CGRect.zero, type: .normal)
        _textFieldView.cornerRadius = DDCTitleTextFieldCell.kTextFieldViewHeight / 2
        _textFieldView.textField?.placeholder = "请输入"
        return _textFieldView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.textFieldView)
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        self.titleLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(self.contentView)
            make.left.equalTo(self.textFieldView)
            make.bottom.equalTo(self.textFieldView.snp_topMargin)
        })
        
        self.textFieldView.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.contentView)
            make.height.equalTo(DDCTitleTextFieldCell.kTextFieldViewHeight)
            make.width.equalTo(DDCTitleTextFieldCell.kCellWidth)
            make.bottom.equalTo(self.contentView).offset(-5)
        })
        
    }
}
