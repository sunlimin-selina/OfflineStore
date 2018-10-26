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

    public lazy var titleLabel: UILabel = {
        let titleLabel : UILabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.gray
        return titleLabel
    }()
    
    public lazy var textFieldView: DDCCircularTextFieldView = {
        let _textFieldView = DDCCircularTextFieldView.init(frame: CGRect.zero, type: .normal)
        _textFieldView.cornerRadius = DDCTitleTextFieldCell.kTextFieldViewHeight / 2
        return _textFieldView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(self.titleLabel)
        self.addSubview(self.textFieldView)
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        self.titleLabel.snp.makeConstraints({ (make) in
            make.top.left.equalTo(self.contentView)
        })
        
        self.textFieldView.snp.makeConstraints({ (make) in
            make.bottom.left.right.equalTo(self.contentView)
            make.height.equalTo(DDCTitleTextFieldCell.kTextFieldViewHeight)
        })
    }
}
