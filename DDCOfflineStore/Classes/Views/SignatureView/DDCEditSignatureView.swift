//
//  DDCEditSignatureView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/2.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCEditSignatureView: UIView {
    lazy var commitButton: DDCBarButton = {
        var _commitButton = DDCBarButton.init(title: "确认", style: .normal, handler: {
            var signature: UIImage = self.signatureView.getSignature()
        })
        return _commitButton
    }()
    
    lazy var titleLabel: UILabel = {
        var _titleLabel = UILabel()
        _titleLabel.text = "请用正楷在白色区域签写姓名"
        _titleLabel.font = UIFont.systemFont(ofSize: 16)
        _titleLabel.textColor = DDCColor.fontColor.gray
        return _titleLabel
    }()
    
    lazy var cancelButton: UIButton = {
        var _cancelButton = UIButton.init(type: .custom)
        _cancelButton.setTitle("X", for: .normal)
        _cancelButton.setTitleColor(UIColor.black, for: .normal)
        return _cancelButton
    }()
    
    lazy var bottomBar: DDCBottomBar = {
        let _bottomBar: DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 10.0, y: 10.0, width: 10.0, height: 10.0))
        _bottomBar.addButton(button:DDCBarButton.init(title: "重置", style: .forbidden, handler: {
            self.signatureView.clearSignature()
            self.titleLabel.isHidden = false
        }))
        
        _bottomBar.addButton(button: self.commitButton)
        return _bottomBar
    }()
    
    lazy var signatureView: DDCDrawSignatureView = {
        let _signatureView: DDCDrawSignatureView = DDCDrawSignatureView.init(frame: CGRect.zero)
        _signatureView.delegate = self
        return _signatureView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.signatureView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.cancelButton)
        self.addSubview(self.bottomBar)
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        self.signatureView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(self.bottomBar.snp_topMargin)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.height.width.equalTo(250)
        }
        
        self.cancelButton.snp.makeConstraints { (make) in
            make.right.top.equalTo(self)
            make.height.width.equalTo(50)
        }
        
        self.bottomBar.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self)
            make.height.equalTo(50)
        }
        
    }
}

extension DDCEditSignatureView: DDCDrawSignatureViewDelegate {
    func signatureView(_ signature: DDCDrawSignatureView, touchesEndedWith path: UIBezierPath) {
        self.commitButton.setStyle(style: .highlighted)
    }
    
    func signatureView(_ signature: DDCDrawSignatureView, touchesBeganWith touches: Set<UITouch>) {
        self.titleLabel.isHidden = true
    }
}
