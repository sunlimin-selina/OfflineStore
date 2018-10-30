//
//  DDCToolbar.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/30.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCToolbar: UIView {
    lazy var lineLabel: UILabel = {
        var _lineLabel: UILabel = UILabel.init(frame: CGRect.zero)
        return _lineLabel
    }()
    
    lazy var cancelButton: UIButton = {
       var _cancelButton = UIButton.init(type: .custom)
        _cancelButton.setTitle("取消", for: .normal)
        _cancelButton.setTitleColor(DDCColor.mainColor.orange, for: .normal)
        _cancelButton.contentHorizontalAlignment = .left
        return _cancelButton
    }()
    
    lazy var doneButton: UIButton = {
        var _doneButton = UIButton.init(type: .custom)
        _doneButton.contentHorizontalAlignment = .right
        _doneButton.setTitle("完成", for: .normal)
        _doneButton.setTitleColor(DDCColor.mainColor.orange, for: .normal)
        return _doneButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.lineLabel)
        self.addSubview(self.doneButton)
        self.addSubview(self.cancelButton)
        self.backgroundColor = UIColor.white

        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        
        self.cancelButton.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        self.lineLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        self.doneButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(self)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }

    }
}
